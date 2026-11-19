# Questão 1 — Variável Aleatória Discreta e Estimação por Máxima Verossimilhança (MLE)

## 1. Introdução e Parâmetro Base

Este documento apresenta o desenvolvimento teórico e a verificação computacional em R da Questão 1 do Homework 2 da disciplina **TI0111 — Statistics for Engineers**. O objetivo consiste em modelar a variável aleatória discreta $X$, que representa o número de requisições que exigem processamento adicional em um lote de $n = 50$ requisições independentes, obter suas medidas resumo, calcular probabilidades de interesse (incluindo os parâmetros $m$, $c$ e $r$ exigidos nas questões subsequentes) e derivar e avaliar o estimador de máxima verossimilhança (MLE) para o parâmetro $p$.

A partir da maior matrícula do grupo, $M = 582416$, define-se a probabilidade individual de uma requisição exigir processamento adicional:

$$p = 0.05 + \frac{M \bmod 100}{200} = 0.05 + \frac{16}{200} = 0.05 + 0.08 = 0.13$$

Todas as verificações numéricas e visualizações foram implementadas em linguagem **R** utilizando apenas pacotes nativos do R base (`stats`, `graphics`, `grDevices`, `utils`), no script [`scripts/questao1.R`](../scripts/questao1.R).

---

## 2. Distribuição de Probabilidade e PMF

### 2.1 Identificação e Justificativa do Modelo

A variável aleatória $X$ segue uma **distribuição Binomial** com parâmetros $n = 50$ e $p = 0.13$:

$$X \sim \text{Binomial}(n = 50, \, p = 0.13)$$

A escolha do modelo Binomial justifica-se porque o experimento satisfaz integralmente as quatro hipóteses de um processo de Bernoulli:

1. **Número fixo de ensaios:** o lote possui exatamente $n = 50$ requisições.
2. **Resultados binários:** cada requisição resulta em um de dois desfechos mutuamente exclusivos — exige processamento adicional ("sucesso") ou não exige ("fracasso").
3. **Probabilidade constante:** cada requisição apresenta a mesma probabilidade de sucesso $p = 0.13$ (e de fracasso $1 - p = 0.87$).
4. **Independência:** o comportamento de uma requisição não interfere no desfecho das demais.

### 2.2 Função de Massa de Probabilidade (PMF) e Suporte

A função de massa de probabilidade (PMF) de $X$ é dada por:

$$P(X = k) = \binom{n}{k} p^k (1 - p)^{n - k} = \binom{50}{k} (0.13)^k (0.87)^{50 - k}$$

com suporte discreto finito:

$$k \in \{0, 1, 2, \dots, 50\}$$

---

## 3. Gráficos da PMF e da CDF em R

O script [`scripts/questao1.R`](../scripts/questao1.R) constrói as representações gráficas adequadas para variáveis aleatórias discretas:

- **PMF (`outputs/q1_pmf.png`):** gráfico de hastes verticais (`type = "h"`) com marcadores nos pontos inteiros do suporte, destacando o valor esperado $E[X] = 6.5$.
- **CDF (`outputs/q1_cdf.png`):** função escada (`type = "s"`), evidenciando a natureza constante por partes e contínua à direita de $F(k) = P(X \le k)$, com destaque para $E[X] = 6.5$ e para o patamar $F(6) = 1 - r \approx 0.5211$.

---

## 4. Medidas Resumo

Para $X \sim \text{Binomial}(n, p)$, as medidas resumo teóricas são:

- **Valor esperado ($m$):**
  $$m = E[X] = n \cdot p = 50 \times 0.13 = 6.5$$

- **Variância:**
  $$\text{Var}(X) = n \cdot p \cdot (1 - p) = 50 \times 0.13 \times 0.87 = 5.655$$

- **Desvio padrão ($c$):**
  $$c = DP(X) = \sqrt{\text{Var}(X)} = \sqrt{5.655} \approx 2.378024$$

| Medida Resumo | Fórmula Teórica | Valor Exato / Aproximado | Uso nas Próximas Questões |
| :--- | :--- | :--- | :--- |
| Valor Esperado $E[X]$ | $n p$ | $6.5$ | $m = 6.5$ (Q2, Q3) |
| Variância $\text{Var}(X)$ | $n p (1 - p)$ | $5.655$ | — |
| Desvio Padrão $DP(X)$ | $\sqrt{n p (1 - p)}$ | $2.378024$ | $c \approx 2.378024$ (Q2) |

Em R, os mesmos valores são confirmados diretamente pela definição discreta da esperança e variância sobre a PMF (`sum(k * dbinom(k, 50, 0.13))` e `sum((k - E_X)^2 * dbinom(k, 50, 0.13))`), coincidindo com os valores teóricos até o limite de precisão de ponto flutuante.

---

## 5. Probabilidades de Interesse e Parâmetro $r$

Utilizando a PMF e a CDF da distribuição $\text{Binomial}(50, 0.13)$:

1. **$P(X \ge 20)$:**
   $$P(X \ge 20) = 1 - P(X \le 19) = \sum_{k=20}^{50} \binom{50}{k}(0.13)^k(0.87)^{50-k} \approx 1.736660 \times 10^{-6}$$

2. **$P(30 < X < 43)$:**
   Como $X$ assume apenas valores inteiros, $30 < X < 43$ equivale a $31 \le X \le 42$:
   $$P(30 < X < 43) = \sum_{k=31}^{42} \binom{50}{k}(0.13)^k(0.87)^{50-k} \approx 8.055445 \times 10^{-16}$$
   *Nota computacional:* em aritmética de ponto flutuante (IEEE 754), calcular $F(42) - F(30)$ diretamente introduz cancelamento catastrófico, pois ambos os valores são extremamente próximos de $1$. Por essa razão, no script em R emprega-se a soma direta da PMF `sum(dbinom(31:42, 50, 0.13))` (equivalente à diferença de caudas superiores via `lower.tail = FALSE`).

3. **$P(X = 31)$:**
   $$P(X = 31) = \binom{50}{31}(0.13)^{31}(0.87)^{19} \approx 7.346292 \times 10^{-16}$$

4. **Parâmetro $r = P(X \ge E[X])$ (exigido na Questão 3):**
   Como $E[X] = 6.5$ e $X$ é discreta inteira, o evento $\{X \ge 6.5\}$ equivale a $\{X \ge 7\}$:
   $$r = P(X \ge 6.5) = P(X \ge 7) = 1 - P(X \le 6) \approx 0.478908$$

| Evento | Expressão Equivalente | Probabilidade |
| :--- | :--- | :--- |
| $P(X \ge 20)$ | $1 - F(19)$ | $1.736660 \times 10^{-6}$ |
| $P(30 < X < 43)$ | $\sum_{k=31}^{42} P(X = k)$ | $8.055445 \times 10^{-16}$ |
| $P(X = 31)$ | $\text{PMF}(31)$ | $7.346292 \times 10^{-16}$ |
| $r = P(X \ge E[X])$ | $1 - F(6)$ | $0.478908$ |

---

## 6. Estimação por Máxima Verossimilhança (MLE)

### 6.1 Função de Verossimilhança e Log-Verossimilhança

Dada uma amostra aleatória $x_1, x_2, \dots, x_n$ de observações i.i.d. com distribuição $\text{Bernoulli}(p)$, seja $k = \sum_{i=1}^{n} x_i$ o número total de sucessos observados. A função de verossimilhança é:

$$L(p \mid k) = \binom{n}{k} p^k (1 - p)^{n - k}, \quad p \in (0, 1)$$

(Nota: o fator combinatório $\binom{n}{k}$ não depende de $p$, de modo que maximizar a verossimilhança Binomial ou a verossimilhança conjunta de Bernoulli $\prod_{i=1}^{n} p^{x_i}(1-p)^{1-x_i} = p^k(1-p)^{n-k}$ conduz exatamente ao mesmo ponto de máximo.)

Aplicando o logaritmo natural, obtém-se a função de log-verossimilhança:

$$\ell(p \mid k) = \ln L(p \mid k) = \ln\binom{n}{k} + k \ln(p) + (n - k) \ln(1 - p)$$

### 6.2 Derivação do Estimador MLE

Derivando $\ell(p \mid k)$ em relação a $p$ e igualando a zero:

$$\frac{d\ell(p \mid k)}{dp} = \frac{k}{p} - \frac{n - k}{1 - p} = 0$$

$$\frac{k}{p} = \frac{n - k}{1 - p} \implies k(1 - p) = p(n - k) \implies k - kp = np - kp \implies np = k$$

Portanto, o estimador de máxima verossimilhança para $p$ é a proporção amostral de sucessos:

$$\hat{p}_{\text{MLE}} = \frac{k}{n} = \frac{1}{n} \sum_{i=1}^{n} x_i = \bar{x}$$

Para verificar que o ponto crítico corresponde a um máximo global, calcula-se a segunda derivada:

$$\frac{d^2\ell(p \mid k)}{dp^2} = -\frac{k}{p^2} - \frac{n - k}{(1 - p)^2} < 0 \quad \text{para todo } p \in (0, 1) \text{ e } 0 < k < n$$

Como a segunda derivada é estritamente negativa, $\ell(p \mid k)$ é estritamente côncava e $\hat{p}_{\text{MLE}} = k/n$ é o ponto de máximo global único.

### 6.3 Desvios em Amostras Finitas e Efeito do Tamanho Amostral

Em amostras finitas (como $n = 50$), o estimador $\hat{p}_{\text{MLE}}$ é uma variável aleatória com:

- **Não viesamento:** $E[\hat{p}] = p = 0.13$.
- **Variância e erro padrão:**
  $$\text{Var}(\hat{p}) = \frac{p(1 - p)}{n}, \qquad EP(\hat{p}) = \sqrt{\frac{0.13 \times 0.87}{50}} \approx 0.04756$$

Em razão da variabilidade amostral inerente a $n = 50$, espera-se que a estimativa empírica $\hat{p}$ apresente desvios típicos da ordem de $\pm 0.048$ (ou aproximadamente $\pm 36\%$ em termos relativos) em torno do valor teórico $p = 0.13$, além da discretização em múltiplos de $1/50 = 0.02$.

À medida que o tamanho amostral $n$ aumenta, o erro padrão decresce à taxa $O(1/\sqrt{n})$, garantindo a **consistência** do estimador pela Lei dos Grandes Números ($\hat{p} \xrightarrow{P} p$ quando $n \to \infty$). Esse comportamento é ilustrado graficamente em `outputs/q1_mle_sample_size.png` e a curva da log-verossimilhança para a amostra de $n = 50$ em `outputs/q1_mle_loglik.png`.

---

## 7. Resumo dos Parâmetros Propagados (Bloco de Entrada para Q2, Q3 e Q4)

| Parâmetro | Definição | Valor |
| :--- | :--- | :--- |
| $M$ | Maior matrícula do grupo | `582416` |
| $p$ | $0.05 + (M \bmod 100) / 200$ | `0.13` |
| $m$ | $E[X]$ | `6.5` |
| $c$ | $DP(X)$ | `2.3780243901` |
| $r$ | $P(X \ge E[X]) = P(X \ge 7)$ | `0.4789079628` |
