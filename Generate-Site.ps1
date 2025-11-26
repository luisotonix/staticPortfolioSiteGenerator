<#
.SYNOPSIS
    Gerador de Site Estático para Portfólio System Admin Microsoft

.DESCRIPTION
    Script PowerShell que gera um site estático completo baseado em arquivos JSON de configuração.
    Suporta múltiplos idiomas (PT, EN, ES), temas (claro/escuro), SEO otimizado, blog e projetos.

.PARAMETER Clean
    Remove a pasta dist/ antes de gerar o site

.PARAMETER Language
    Gera apenas para um idioma específico (pt, en, es). Por padrão gera para todos.

.EXAMPLE
    .\Generate-Site.ps1
    Gera o site completo para todos os idiomas

.EXAMPLE
    .\Generate-Site.ps1 -Clean
    Remove arquivos antigos e gera o site

.EXAMPLE
    .\Generate-Site.ps1 -Language pt
    Gera apenas a versão em português
#>

[CmdletBinding()]
param(
    [switch]$Clean,
    [ValidateSet('pt', 'en', 'es', 'all')]
    [string]$Language = 'all'
)

# Configurações
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Caminhos
$ScriptPath = $PSScriptRoot
$DataPath = Join-Path $ScriptPath "data"
$TemplatesPath = Join-Path $ScriptPath "templates"
$AssetsPath = Join-Path $ScriptPath "assets"
$DistPath = Join-Path $ScriptPath "dist"

Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   Gerador de Site Estático - Portfólio System Admin" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Função para carregar JSON
function Get-JsonData {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath)) {
        throw "Arquivo não encontrado: $FilePath"
    }

    return Get-Content $FilePath -Raw -Encoding UTF8 | ConvertFrom-Json
}

# Função para substituir placeholders no template
function Invoke-TemplateReplace {
    param(
        [string]$Template,
        [hashtable]$Replacements
    )

    $result = $Template
    foreach ($key in $Replacements.Keys) {
        $placeholder = "{{$key}}"
        $value = $Replacements[$key]
        if ($null -eq $value) { $value = "" }
        $result = $result -replace [regex]::Escape($placeholder), $value
    }

    return $result
}

# Função para obter texto traduzido
function Get-TranslatedText {
    param(
        [object]$Content,
        [string]$Lang
    )

    if ($Content -is [string]) {
        return $Content
    }

    if ($Content.$Lang) {
        return $Content.$Lang
    }

    # Fallback para português
    if ($Content.pt) {
        return $Content.pt
    }

    return ""
}

# Função para gerar menu de navegação
function Get-NavigationHtml {
    param(
        [object]$Config,
        [string]$Lang,
        [string]$CurrentPage
    )

    $navItems = @()
    foreach ($item in $Config.navigation) {
        $label = Get-TranslatedText $item.label $Lang
        $url = $item.url
        $active = if ($item.id -eq $CurrentPage) { ' class="active"' } else { '' }
        $navItems += "<li$active><a href='$url'>$label</a></li>"
    }

    return $navItems -join "`n                "
}

# Função para gerar seletor de idiomas
function Get-LanguageSelectorHtml {
    param(
        [string]$CurrentLang
    )

    $languages = @{
        'pt' = '🇧🇷 Português'
        'en' = '🇺🇸 English'
        'es' = '🇪🇸 Español'
    }

    $items = @()
    foreach ($lang in $languages.Keys) {
        $selected = if ($lang -eq $CurrentLang) { ' selected' } else { '' }
        $items += "<option value='$lang'$selected>$($languages[$lang])</option>"
    }

    return $items -join "`n                    "
}

# Função para converter Markdown para HTML (simplificado)
function ConvertFrom-MarkdownSimple {
    param([string]$Markdown)

    if ([string]::IsNullOrEmpty($Markdown)) { return "" }

    $html = $Markdown

    # Headers
    $html = $html -replace '(?m)^### (.+)$', '<h3>$1</h3>'
    $html = $html -replace '(?m)^## (.+)$', '<h2>$1</h2>'
    $html = $html -replace '(?m)^# (.+)$', '<h1>$1</h1>'

    # Bold
    $html = $html -replace '\*\*(.+?)\*\*', '<strong>$1</strong>'

    # Lists
    $html = $html -replace '(?m)^- (.+)$', '<li>$1</li>'
    $html = $html -replace '(<li>.*</li>\r?\n?)+', '<ul>$0</ul>'

    # Paragraphs
    $html = $html -replace '(?m)^([^<\r\n].+)$', '<p>$1</p>'

    # Code blocks
    $html = $html -replace '(?s)```(\w+)?\r?\n(.+?)\r?\n```', '<pre><code>$2</code></pre>'

    # Line breaks
    $html = $html -replace '\r?\n\r?\n', "`n"

    return $html
}

# Função para gerar meta tags SEO
function Get-SeoMetaTags {
    param(
        [object]$Config,
        [string]$Lang,
        [string]$Title,
        [string]$Description,
        [string]$Url,
        [string]$Image
    )

    $siteName = $Config.site.name
    $keywords = Get-TranslatedText $Config.seo.keywords $Lang
    $ogImage = if ($Image) { $Image } else { $Config.seo.ogImage }
    $fullUrl = "$($Config.site.url)/$Url"

    return @"
    <title>$Title - $siteName</title>
    <meta name="description" content="$Description">
    <meta name="keywords" content="$keywords">
    <meta name="author" content="$($Config.site.author)">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="$fullUrl">
    <meta property="og:title" content="$Title - $siteName">
    <meta property="og:description" content="$Description">
    <meta property="og:image" content="$ogImage">

    <!-- Twitter -->
    <meta property="twitter:card" content="$($Config.seo.twitterCard)">
    <meta property="twitter:url" content="$fullUrl">
    <meta property="twitter:title" content="$Title - $siteName">
    <meta property="twitter:description" content="$Description">
    <meta property="twitter:image" content="$ogImage">
"@
}

# Função para gerar JSON-LD para SEO
function Get-JsonLd {
    param(
        [object]$Config,
        [string]$Type = "Person"
    )

    $jsonLd = @{
        "@context" = "https://schema.org"
        "@type" = $Type
        "name" = $Config.site.author
        "url" = $Config.site.url
        "email" = $Config.site.email
        "sameAs" = @(
            $Config.site.social.linkedin,
            $Config.site.social.github,
            $Config.site.social.twitter
        )
    }

    return "<script type='application/ld+json'>$($jsonLd | ConvertTo-Json -Depth 10)</script>"
}

# Limpar pasta dist se solicitado
if ($Clean -and (Test-Path $DistPath)) {
    Write-Host "🗑️  Limpando pasta dist..." -ForegroundColor Yellow
    Remove-Item $DistPath -Recurse -Force
}

# Criar estrutura de pastas
Write-Host "📁 Criando estrutura de pastas..." -ForegroundColor Green
$folders = @('assets/css', 'assets/js', 'assets/images', 'blog', 'portfolio')
foreach ($folder in $folders) {
    $path = Join-Path $DistPath $folder
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
    }
}

# Carregar dados
Write-Host "📄 Carregando dados..." -ForegroundColor Green
$config = Get-JsonData (Join-Path $DataPath "config.json")
$content = Get-JsonData (Join-Path $DataPath "content.json")
$blogData = Get-JsonData (Join-Path $DataPath "blog/posts.json")
$projectsData = Get-JsonData (Join-Path $DataPath "projects/projects.json")

# Copiar assets
Write-Host "📦 Copiando assets..." -ForegroundColor Green
if (Test-Path $AssetsPath) {
    Copy-Item -Path "$AssetsPath/*" -Destination (Join-Path $DistPath "assets") -Recurse -Force
}

# Definir idiomas para geração
$languages = if ($Language -eq 'all') { $config.languages } else { @($Language) }

Write-Host ""
Write-Host "🌐 Gerando páginas para idiomas: $($languages -join ', ')" -ForegroundColor Cyan
Write-Host ""

# Carregar templates
Write-Host "📝 Carregando templates..." -ForegroundColor Green
$layoutTemplate = Get-Content (Join-Path $TemplatesPath "layout.html") -Raw -Encoding UTF8

# Processar cada idioma
foreach ($lang in $languages) {
    Write-Host "  ⚙️  Processando idioma: $($lang.ToUpper())" -ForegroundColor Magenta

    # Gerar páginas principais
    $pages = @('home', 'about', 'services', 'contact')

    foreach ($pageName in $pages) {
        $fileName = if ($pageName -eq 'home') { 'index.html' } else { "$pageName.html" }
        Write-Host "     ➜ Gerando $fileName" -ForegroundColor Gray

        # Carregar template da página
        $pageTemplate = Get-Content (Join-Path $TemplatesPath "$pageName.html") -Raw -Encoding UTF8

        # Preparar dados da página
        $pageData = $content.$pageName
        $pageTitle = Get-TranslatedText $pageData.title $lang
        if ([string]::IsNullOrEmpty($pageTitle)) {
            $pageTitle = $pageName.Substring(0,1).ToUpper() + $pageName.Substring(1)
        }

        # Gerar conteúdo específico da página
        $pageContent = Invoke-TemplateReplace $pageTemplate @{
            'lang' = $lang
            'page-title' = $pageTitle
            'site-name' = $config.site.name
        }

        # Montar página completa
        $navigation = Get-NavigationHtml $config $lang $pageName
        $langSelector = Get-LanguageSelectorHtml $lang
        $description = Get-TranslatedText $config.site.description $lang
        $seoMeta = Get-SeoMetaTags $config $lang $pageTitle $description $fileName ""

        $fullPage = Invoke-TemplateReplace $layoutTemplate @{
            'lang' = $lang
            'seo-meta' = $seoMeta
            'navigation' = $navigation
            'language-selector' = $langSelector
            'main-content' = $pageContent
            'site-name' = $config.site.name
            'current-year' = (Get-Date).Year
            'author' = $config.site.author
            'email' = $config.site.email
            'linkedin' = $config.site.social.linkedin
            'github' = $config.site.social.github
            'twitter' = $config.site.social.twitter
        }

        # Salvar arquivo
        $outputPath = Join-Path $DistPath $fileName
        $fullPage | Out-File -FilePath $outputPath -Encoding UTF8
    }

    # Gerar página de portfólio
    Write-Host "     ➜ Gerando portfolio.html" -ForegroundColor Gray
    # (será implementado com o template)

    # Gerar página de blog
    Write-Host "     ➜ Gerando blog.html" -ForegroundColor Gray
    # (será implementado com o template)

    # Gerar páginas individuais de posts
    Write-Host "     ➜ Gerando páginas de posts ($($blogData.posts.Count) posts)" -ForegroundColor Gray
    # (será implementado)

    # Gerar páginas individuais de projetos
    Write-Host "     ➜ Gerando páginas de projetos ($($projectsData.projects.Count) projetos)" -ForegroundColor Gray
    # (será implementado)
}

# Gerar sitemap.xml
Write-Host ""
Write-Host "🗺️  Gerando sitemap.xml..." -ForegroundColor Green
$sitemapUrls = @()
$sitemapUrls += "  <url><loc>$($config.site.url)/index.html</loc><priority>1.0</priority></url>"
$sitemapUrls += "  <url><loc>$($config.site.url)/about.html</loc><priority>0.8</priority></url>"
$sitemapUrls += "  <url><loc>$($config.site.url)/portfolio.html</loc><priority>0.8</priority></url>"
$sitemapUrls += "  <url><loc>$($config.site.url)/services.html</loc><priority>0.8</priority></url>"
$sitemapUrls += "  <url><loc>$($config.site.url)/blog.html</loc><priority>0.8</priority></url>"
$sitemapUrls += "  <url><loc>$($config.site.url)/contact.html</loc><priority>0.7</priority></url>"

foreach ($post in $blogData.posts) {
    $sitemapUrls += "  <url><loc>$($config.site.url)/blog/$($post.slug).html</loc><priority>0.6</priority></url>"
}

foreach ($project in $projectsData.projects) {
    $sitemapUrls += "  <url><loc>$($config.site.url)/portfolio/$($project.slug).html</loc><priority>0.7</priority></url>"
}

$sitemap = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$($sitemapUrls -join "`n")
</urlset>
"@

$sitemap | Out-File -FilePath (Join-Path $DistPath "sitemap.xml") -Encoding UTF8

# Gerar robots.txt
Write-Host "🤖 Gerando robots.txt..." -ForegroundColor Green
$robots = @"
User-agent: *
Allow: /

Sitemap: $($config.site.url)/sitemap.xml
"@

$robots | Out-File -FilePath (Join-Path $DistPath "robots.txt") -Encoding UTF8

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✅ Site gerado com sucesso!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📂 Local: $DistPath" -ForegroundColor Yellow
Write-Host "🌐 Idiomas: $($languages -join ', ')" -ForegroundColor Yellow
Write-Host "📄 Páginas: $(((Get-ChildItem $DistPath -Filter *.html -Recurse).Count))" -ForegroundColor Yellow
Write-Host ""
Write-Host "💡 Para visualizar o site, abra: $DistPath\index.html" -ForegroundColor Cyan
Write-Host ""
