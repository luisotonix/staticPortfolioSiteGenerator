# 🚀 Gerador de Site Estático para Portfólio System Admin Microsoft

Um gerador de site estático poderoso e moderno em PowerShell, projetado especialmente para profissionais System Admin especializados em tecnologias Microsoft (Azure, Microsoft 365, Power Platform).

## ✨ Características

### 🎨 Design Moderno e Responsivo
- Interface elegante e profissional
- Totalmente responsivo (mobile-first)
- Animações suaves e transições
- Design limpo e focado em conteúdo

### 🌓 Temas Claro/Escuro
- Suporte a temas claro e escuro
- Modo automático que segue preferência do navegador
- Seletor manual de tema
- Persistência da escolha do usuário

### 🌍 Multi-idioma (i18n)
- Suporte para Português, Inglês e Espanhol
- Detecção automática do idioma do navegador
- Seletor manual de idioma
- Fácil adicionar novos idiomas

### 📱 Páginas Incluídas
- **Home**: Página inicial com destaque para projetos
- **Sobre**: Biografia, skills, certificações
- **Portfólio**: Projetos com filtros por categoria
- **Serviços**: Serviços oferecidos
- **Blog**: Sistema de blog completo com categorias e tags
- **Contato**: Formulário de contato

### 📝 Sistema de Blog
- Posts em Markdown
- Categorias e tags
- Filtros dinâmicos
- Integração com Disqus para comentários
- Botões de compartilhamento social
- Páginas individuais para cada post

### 💼 Portfólio de Projetos
- Páginas detalhadas para cada projeto
- Seções: Desafio, Solução, Resultados
- Galeria de imagens
- Tecnologias utilizadas
- Depoimentos de clientes

### 🔍 SEO Otimizado
- Meta tags completas
- Open Graph para redes sociais
- Twitter Cards
- JSON-LD para rich snippets
- Sitemap.xml automático
- Robots.txt

### ⚡ Performance
- HTML/CSS/JavaScript puro (sem frameworks pesados)
- Lazy loading de imagens
- Assets otimizados
- Código limpo e minificável

## 📋 Requisitos

- **PowerShell 5.1+** (Windows) ou **PowerShell Core 7+** (Windows/Linux/macOS)
- Navegador web moderno para visualização

## 🚀 Instalação e Uso

### 1. Clone ou Baixe o Repositório

```bash
git clone https://github.com/seu-usuario/staticPortfolioSiteGenerator.git
cd staticPortfolioSiteGenerator
```

### 2. Configure seus Dados

Edite os arquivos JSON na pasta `data/`:

#### `data/config.json`
Configure informações gerais do site, navegação, SEO e redes sociais.

```json
{
  "site": {
    "name": "Seu Nome",
    "author": "Seu Nome Completo",
    "email": "seu@email.com",
    "url": "https://seudominio.com"
  }
}
```

#### `data/content.json`
Configure o conteúdo das páginas principais (Home, Sobre, Serviços, Contato).

#### `data/blog/posts.json`
Adicione seus posts de blog.

#### `data/projects/projects.json`
Adicione seus projetos do portfólio.

### 3. Gere o Site

Execute o script PowerShell:

```powershell
# Gerar para todos os idiomas
.\Generate-Site.ps1

# Limpar e regenerar
.\Generate-Site.ps1 -Clean

# Gerar apenas para português
.\Generate-Site.ps1 -Language pt
```

### 4. Visualize o Site

Abra o arquivo `dist/index.html` em seu navegador ou use um servidor web local:

```powershell
# Com Python
cd dist
python -m http.server 8000

# Com Node.js (npx)
cd dist
npx serve

# Com PHP
cd dist
php -S localhost:8000
```

Acesse: `http://localhost:8000`

## 📁 Estrutura do Projeto

```
staticPortfolioSiteGenerator/
├── data/                          # Dados em JSON
│   ├── config.json               # Configurações gerais
│   ├── content.json              # Conteúdo das páginas
│   ├── blog/
│   │   └── posts.json            # Posts do blog
│   └── projects/
│       └── projects.json         # Projetos do portfólio
│
├── templates/                     # Templates HTML
│   ├── layout.html               # Layout base
│   ├── home.html                 # Página inicial
│   ├── about.html                # Sobre
│   ├── portfolio.html            # Lista de projetos
│   ├── services.html             # Serviços
│   ├── blog.html                 # Lista de posts
│   ├── blog-post.html            # Post individual
│   ├── project.html              # Projeto individual
│   └── contact.html              # Contato
│
├── assets/                        # Assets estáticos
│   ├── css/
│   │   └── style.css             # Estilos CSS
│   ├── js/
│   │   └── main.js               # JavaScript
│   └── images/                   # Imagens
│
├── dist/                          # Site gerado (criado automaticamente)
│
├── Generate-Site.ps1              # Script gerador
└── README.md                      # Esta documentação
```

## 🎨 Personalização

### Cores e Temas

Edite as variáveis CSS em `assets/css/style.css`:

```css
:root {
    --color-primary: #0078d4;      /* Cor primária */
    --color-secondary: #107c10;    /* Cor secundária */
    --color-accent: #ffb900;       /* Cor de destaque */
}
```

### Adicionar Novo Idioma

1. Adicione o código do idioma em `data/config.json`:
```json
{
  "languages": ["pt", "en", "es", "fr"]
}
```

2. Adicione traduções em todos os objetos JSON:
```json
{
  "title": {
    "pt": "Título em Português",
    "en": "Title in English",
    "es": "Título en Español",
    "fr": "Titre en Français"
  }
}
```

### Adicionar Nova Página

1. Crie o template em `templates/novapage.html`
2. Adicione o conteúdo em `data/content.json`
3. Adicione à navegação em `data/config.json`
4. Atualize `Generate-Site.ps1` para processar a nova página

### Integração com Disqus

1. Crie uma conta em [Disqus](https://disqus.com/)
2. Obtenha seu shortname
3. Configure em `data/config.json`:
```json
{
  "disqus": {
    "shortname": "seu-shortname-disqus"
  }
}
```

### Formulário de Contato

O template usa [Formspree](https://formspree.io/) por padrão. Alternativas:
- Google Forms
- Netlify Forms
- Seu próprio backend

## 📝 Adicionando Conteúdo

### Novo Post do Blog

Edite `data/blog/posts.json` e adicione:

```json
{
  "id": "meu-novo-post",
  "title": {
    "pt": "Meu Novo Post",
    "en": "My New Post",
    "es": "Mi Nuevo Post"
  },
  "slug": "meu-novo-post",
  "date": "2024-11-26",
  "author": "Seu Nome",
  "excerpt": {
    "pt": "Resumo do post..."
  },
  "content": {
    "pt": "# Conteúdo completo em Markdown\n\n..."
  },
  "categories": ["Azure", "PowerShell"],
  "tags": ["azure", "automation"]
}
```

### Novo Projeto

Edite `data/projects/projects.json` e adicione:

```json
{
  "id": "meu-projeto",
  "title": {
    "pt": "Nome do Projeto"
  },
  "slug": "meu-projeto",
  "category": "Azure",
  "date": "2024-11",
  "summary": {
    "pt": "Resumo do projeto..."
  },
  "challenge": {
    "pt": "Descrição do desafio..."
  },
  "solution": {
    "pt": "Descrição da solução..."
  },
  "results": {
    "pt": "Resultados obtidos..."
  },
  "technologies": ["Azure", "PowerShell", "Azure AD"]
}
```

## 🚀 Deploy

### GitHub Pages

1. Crie um repositório no GitHub
2. Faça push do projeto
3. Configure GitHub Pages para usar a pasta `dist`
4. Seu site estará disponível em: `https://seuusuario.github.io/repo`

### Netlify

1. Conecte seu repositório
2. Configure:
   - Build command: `pwsh -File Generate-Site.ps1`
   - Publish directory: `dist`
3. Deploy automático a cada commit

### Vercel

Similar ao Netlify:
1. Importe o repositório
2. Configure o build
3. Deploy

### Hospedagem Tradicional

1. Gere o site: `.\Generate-Site.ps1`
2. Faça upload da pasta `dist/` via FTP
3. Configure seu domínio

## 🛠️ Desenvolvimento

### Estrutura do Script PowerShell

O `Generate-Site.ps1` realiza:
1. Carrega dados dos arquivos JSON
2. Processa templates HTML
3. Substitui placeholders com conteúdo
4. Gera páginas para cada idioma
5. Cria sitemap.xml e robots.txt
6. Copia assets para dist/

### Funções Principais

- `Get-JsonData`: Carrega arquivos JSON
- `Invoke-TemplateReplace`: Substitui placeholders
- `Get-TranslatedText`: Obtém texto no idioma correto
- `Get-SeoMetaTags`: Gera meta tags SEO
- `ConvertFrom-MarkdownSimple`: Converte Markdown para HTML

## 📚 Tecnologias Utilizadas

- **PowerShell**: Geração do site
- **HTML5**: Marcação semântica
- **CSS3**: Estilos modernos com variáveis CSS
- **JavaScript (Vanilla)**: Funcionalidades interativas
- **JSON**: Armazenamento de dados

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 🙏 Agradecimentos

- Microsoft Design System para inspiração visual
- Comunidade PowerShell
- Todos os contribuidores

## 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/seu-usuario/staticPortfolioSiteGenerator/issues)
- **Email**: seu@email.com

## 🗺️ Roadmap

- [ ] Suporte a temas customizados
- [ ] Gerador de thumbnails automático
- [ ] Minificação automática de CSS/JS
- [ ] PWA (Progressive Web App)
- [ ] Busca no site
- [ ] RSS Feed
- [ ] Modo offline

---

Desenvolvido com ❤️ para a comunidade System Admin
