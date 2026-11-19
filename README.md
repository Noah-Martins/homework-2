# TI0111 — Statistics for Engineers | Homework 2

Repositório oficial do **Homework 2** da disciplina **TI0111 — Statistics for Engineers**, contendo o desenvolvimento teórico, os scripts em linguagem **R**, as saídas gráficas/tabulares e a documentação do projeto.

---

## 1. Descrição do Projeto

O trabalho investiga conceitos fundamentais de probabilidade, simulação estocástica e inferência estatística aplicados a um cenário de sistemas computacionais, estruturado em quatro questões interdependentes:

1. **Questão 1 (Concluída):** Modelagem discreta de requisições com processamento adicional ($X \sim \text{Binomial}(n = 50, p)$), PMF, CDF, medidas resumo, probabilidades e Estimação por Máxima Verossimilhança (MLE).
2. **Questão 2 (Pendente):** Aproximação de Poisson para alertas críticos diários ($Y$) e simulação Binomial exata.
3. **Questão 3 (Pendente):** Modelagem Normal da temperatura da CPU ($T \sim N(62, 3.5^2)$) com implementação própria da Transformação de Box-Muller e comparação com o gerador nativo do R.
4. **Questão 4 (Pendente):** Amostra pareada $(X, T)$, dispersão, correlação de Pearson, regressão linear simples (OLS) e análise de resíduos.

---

## 2. Parâmetro Base e Parâmetros Propagados (Questão 1)

Com base na maior matrícula da equipe ($M = 582416$), calcula-se o parâmetro base:

$$p = 0.05 + \frac{M \bmod 100}{200} = 0.05 + \frac{16}{200} = 0.13$$

Os parâmetros obtidos na Questão 1 e obrigatórios para as Questões 2, 3 e 4 são:

| Parâmetro | Definição | Valor | Utilizado em |
| :--- | :--- | :--- | :--- |
| $M$ | Maior matrícula do grupo | `582416` | Fase 1 |
| $p$ | $0.05 + (M \bmod 100)/200$ | `0.13` | Q1, Q4 |
| $m$ | $E[X] = n p$ | `6.5` | Q2, Q3 |
| $c$ | $DP(X) = \sqrt{n p (1-p)}$ | `2.378024` | Q2 |
| $r$ | $P(X \ge E[X]) = P(X \ge 7)$ | `0.478908` | Q3 |

---

## 3. Estrutura do Repositório

```text
homework-2/
├── README.md          # Descrição do projeto, instruções e contribuições
├── .gitignore         # Arquivos temporários do R ignorados pelo Git
├── scripts/
│   └── questao1.R     # Script R executável da Questão 1 (PMF, CDF, MLE)
└── outputs/           # Gráficos (PNG) e parâmetros exportados (CSV/RDS)
```

---

## 4. Dependências e Instruções de Execução

### Dependências

- **R** (versão 4.0 ou superior recomendada).
- **Pacotes necessários:** apenas pacotes nativos do R base (`stats`, `graphics`, `grDevices`, `utils`). Não é necessário instalar pacotes externos para a Questão 1.

### Como Executar

A partir da raiz do repositório, execute no terminal:

```bash
Rscript scripts/questao1.R
```

Ou, dentro do R / RStudio (com o diretório de trabalho definido na raiz do repositório):

```r
source("scripts/questao1.R")
```

### Saídas Geradas

Ao executar `scripts/questao1.R`, os seguintes arquivos são criados automaticamente na pasta `outputs/`:

- `outputs/q1_pmf.png` — Gráfico de hastes da PMF de $X \sim \text{Binomial}(50, 0.13)$.
- `outputs/q1_cdf.png` — Gráfico em escada da CDF de $X \sim \text{Binomial}(50, 0.13)$.
- `outputs/q1_mle_loglik.png` — Curva de log-verossimilhança $\ell(p \mid k)$ comparando $\hat{p}_{\text{MLE}}$ e $p = 0.13$.
- `outputs/q1_mle_sample_size.png` — Convergência de $\hat{p}_{\text{MLE}}$ com o aumento do tamanho amostral $n$.
- `outputs/q1_parameters.csv` e `outputs/q1_parameters.rds` — Parâmetros $M, p, m, c, r$ exportados para reutilização direta nas Questões 2, 3 e 4.

---

## 5. Checklist do Plano de Execução

- [x] **Fase 1:** Setup do repositório Git e cálculo do parâmetro base ($M = 582416 \Rightarrow p = 0.13$).
- [x] **Fase 2:** Questão 1 — Desenvolvimento teórico e código R (PMF, CDF, $E[X]$, $DP(X)$, probabilidades, $r$ e MLE).
- [ ] **Fase 3:** Questões 2 e 3 — Aproximação de Poisson e Normal com Transformação de Box-Muller.
- [ ] **Fase 4:** Questão 4 — Correlação de Pearson, Regressão Linear Simples (OLS) e análise de resíduos.
- [ ] **Fase 5:** Relatório técnico final em PDF e revisão final dos scripts R.
- [ ] **Fase 6:** Revisão do `README.md`, push final no GitHub e submissão no SIGAA.

---

## 6. Equipe e Contribuições Individuais

> *Preencher com os nomes completos, matrículas e contribuições específicas de cada integrante do grupo (3 a 4 estudantes).*

| Integrante | Matrícula | Contribuições |
| :--- | :--- | :--- |
| **Noah Martins** *(ajustar se necessário)* | `582416` | Setup do repositório, cálculo do parâmetro base ($p$), Questão 1 (teoria e código R) e estruturação do `README.md`. |
| *Integrante 2* | `XXXXXX` | *A definir (ex.: Questão 2 — Aproximação de Poisson)* |
| *Integrante 3* | `XXXXXX` | *A definir (ex.: Questão 3 — Box-Muller e Normal)* |
| *Integrante 4 (opcional)* | `XXXXXX` | *A definir (ex.: Questão 4 — Correlação e Regressão / Relatório PDF)* |
