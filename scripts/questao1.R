# ==============================================================================
# TI0111 - Statistics for Engineers | Homework 2
# Questão 1: Variável Aleatória Discreta (Binomial) e Estimação por Máxima
#            Verossimilhança (MLE)
# ==============================================================================
#
# Dependências:
#   - Apenas pacotes nativos do R base (stats, graphics, grDevices, utils).
#   - Nenhum pacote externo é necessário.
#
# Execução (a partir da raiz do repositório):
#   Rscript scripts/questao1.R
#
# Saídas geradas em outputs/:
#   - outputs/q1_pmf.png              : Gráfico da PMF de X ~ Binomial(50, 0.13)
#   - outputs/q1_cdf.png              : Gráfico da CDF de X ~ Binomial(50, 0.13)
#   - outputs/q1_mle_loglik.png       : Curva da log-verossimilhança e MLE
#   - outputs/q1_mle_sample_size.png  : Efeito do tamanho amostral em p_hat
#   - outputs/q1_parameters.csv       : Parâmetros exportados para Q2, Q3 e Q4
#   - outputs/q1_parameters.rds       : Objeto R com parâmetros para Q2, Q3 e Q4
# ==============================================================================

# Garantir diretório de saída
output_dir <- "outputs"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# ==============================================================================
# FASE 1: Parâmetro Base da Equipe
# ==============================================================================
M <- 582416L                          # Maior matrícula do grupo
p <- 0.05 + (M %% 100) / 200          # p = 0.05 + 16 / 200 = 0.13
n <- 50L                              # Tamanho do lote de requisições

cat("====================================================================\n")
cat("FASE 1 - PARAMETRO BASE\n")
cat("====================================================================\n")
cat(sprintf("Maior matricula (M) : %d\n", M))
cat(sprintf("M mod 100           : %d\n", M %% 100))
cat(sprintf("Parametro p         : %.4f\n", p))
cat(sprintf("Tamanho do lote (n) : %d\n\n", n))

# ==============================================================================
# QUESTÃO 1.1: Distribuição e Função de Massa de Probabilidade (PMF)
# ==============================================================================
# Modelo: X ~ Binomial(n = 50, p = 0.13)
# Suporte: k in {0, 1, 2, ..., 50}
# PMF: P(X = k) = choose(n, k) * p^k * (1 - p)^(n - k)

k_vals <- 0:n
pmf_vals <- dbinom(k_vals, size = n, prob = p)
cdf_vals <- pbinom(k_vals, size = n, prob = p)

# Verificação de normalização da PMF
cat("====================================================================\n")
cat("QUESTAO 1.1 - DISTRIBUICAO E PMF\n")
cat("====================================================================\n")
cat(sprintf("Modelo: X ~ Binomial(n = %d, p = %.2f)\n", n, p))
cat(sprintf("Soma da PMF no suporte {0..%d}: %.12f\n\n", n, sum(pmf_vals)))

# ==============================================================================
# QUESTÃO 1.3: Medidas Resumo (Teoria vs. Verificação em R)
# ==============================================================================
# Fórmulas teóricas para X ~ Binomial(n, p):
#   E[X]   = n * p
#   Var(X) = n * p * (1 - p)
#   DP(X)  = sqrt(Var(X))

E_X_teorico   <- n * p
Var_X_teorico <- n * p * (1 - p)
DP_X_teorico  <- sqrt(Var_X_teorico)

# Verificação numérica em R pela definição discreta da PMF:
E_X_R   <- sum(k_vals * pmf_vals)
Var_X_R <- sum((k_vals - E_X_R)^2 * pmf_vals)
DP_X_R  <- sqrt(Var_X_R)

# Parâmetros obrigatórios para as Questões 2, 3 e 4:
m <- E_X_teorico
c_param <- DP_X_teorico

cat("====================================================================\n")
cat("QUESTAO 1.3 - MEDIDAS RESUMO\n")
cat("====================================================================\n")
cat(sprintf("E[X]   (teorico) = %.6f | (R via PMF) = %.6f\n", E_X_teorico, E_X_R))
cat(sprintf("Var(X) (teorico) = %.6f | (R via PMF) = %.6f\n", Var_X_teorico, Var_X_R))
cat(sprintf("DP(X)  (teorico) = %.6f | (R via PMF) = %.6f\n\n", DP_X_teorico, DP_X_R))

# ==============================================================================
# QUESTÃO 1.4: Cálculo de Probabilidades e Parâmetro r
# ==============================================================================
# 1) P(X >= 20) = 1 - P(X <= 19)
prob_ge_20 <- pbinom(19, size = n, prob = p, lower.tail = FALSE)
prob_ge_20_check <- sum(dbinom(20:n, size = n, prob = p))

# 2) P(30 < X < 43) = P(31 <= X <= 42)
# Nota numérica: usa-se a soma direta da PMF (ou diferença de caudas superiores)
# para evitar cancelamento catastrófico em ponto flutuante.
prob_30_to_43 <- sum(dbinom(31:42, size = n, prob = p))
prob_30_to_43_tail <- pbinom(30, size = n, prob = p, lower.tail = FALSE) -
  pbinom(42, size = n, prob = p, lower.tail = FALSE)

# 3) P(X = 31)
prob_eq_31 <- dbinom(31, size = n, prob = p)

# 4) r = P(X >= E[X]) = P(X >= 6.5) = P(X >= 7) = 1 - P(X <= 6)
limiar_r <- ceiling(E_X_teorico)
r_param <- pbinom(limiar_r - 1, size = n, prob = p, lower.tail = FALSE)
r_param_check <- sum(dbinom(limiar_r:n, size = n, prob = p))

cat("====================================================================\n")
cat("QUESTAO 1.4 - PROBABILIDADES\n")
cat("====================================================================\n")
cat(sprintf("P(X >= 20)          = %.10e (check soma PMF: %.10e)\n",
            prob_ge_20, prob_ge_20_check))
cat(sprintf("P(30 < X < 43)      = %.10e (check cauda sup: %.10e)\n",
            prob_30_to_43, prob_30_to_43_tail))
cat(sprintf("P(X = 31)           = %.10e\n", prob_eq_31))
cat(sprintf("r = P(X >= E[X])    = P(X >= %d) = %.10f (check: %.10f)\n\n",
            limiar_r, r_param, r_param_check))

# ==============================================================================
# QUESTÃO 1.2: Gráficos da PMF e da CDF em R
# ==============================================================================
# Gráfico 1: PMF de X (gráfico de hastes verticais para variável discreta)
png(filename = file.path(output_dir, "q1_pmf.png"),
    width = 1800, height = 1200, res = 220)
par(mar = c(5, 5, 4, 2) + 0.1)
plot(
  k_vals, pmf_vals,
  type = "h",
  lwd = 2.5,
  col = "#1F4E79",
  xlab = "Número de requisições com processamento adicional (k)",
  ylab = "Probabilidade P(X = k)",
  main = "Função de Massa de Probabilidade (PMF) — X ~ Binomial(n = 50, p = 0.13)",
  xlim = c(0, 25),
  ylim = c(0, max(pmf_vals) * 1.15),
  las = 1
)
grid(col = "gray85", lty = "dotted")
lines(k_vals, pmf_vals, type = "h", lwd = 2.5, col = "#1F4E79")
points(k_vals, pmf_vals, pch = 19, cex = 0.9, col = "#1F4E79")
abline(v = E_X_teorico, col = "#C0392B", lwd = 2, lty = 2)
legend(
  "topright",
  legend = c(
    "PMF: P(X = k)",
    sprintf("Valor Esperado E[X] = %.2f", E_X_teorico)
  ),
  col = c("#1F4E79", "#C0392B"),
  lwd = c(2.5, 2),
  lty = c(1, 2),
  pch = c(19, NA),
  bg = "white",
  bty = "o"
)
mtext("Nota: Eixo horizontal exibido em [0, 25], pois P(X > 25) < 10^-9.",
      side = 1, line = 3.8, cex = 0.8, col = "gray35")
dev.off()

# Gráfico 2: CDF de X (função escada para variável discreta)
png(filename = file.path(output_dir, "q1_cdf.png"),
    width = 1800, height = 1200, res = 220)
par(mar = c(5, 5, 4, 2) + 0.1)
plot(
  k_vals, cdf_vals,
  type = "s",
  lwd = 2.5,
  col = "#1F4E79",
  xlab = "Número de requisições com processamento adicional (k)",
  ylab = "Probabilidade Acumulada F(k) = P(X <= k)",
  main = "Função de Distribuição Acumulada (CDF) — X ~ Binomial(n = 50, p = 0.13)",
  xlim = c(0, 25),
  ylim = c(0, 1.05),
  las = 1
)
grid(col = "gray85", lty = "dotted")
lines(k_vals, cdf_vals, type = "s", lwd = 2.5, col = "#1F4E79")
points(k_vals, cdf_vals, pch = 19, cex = 0.7, col = "#1F4E79")
abline(v = E_X_teorico, col = "#C0392B", lwd = 2, lty = 2)
abline(h = 1 - r_param, col = "#2E7D32", lwd = 1.8, lty = 3)
legend(
  "bottomright",
  legend = c(
    "CDF: F(k) = P(X <= k)",
    sprintf("E[X] = %.2f", E_X_teorico),
    sprintf("F(6) = 1 - r = %.4f (r = %.4f)", 1 - r_param, r_param)
  ),
  col = c("#1F4E79", "#C0392B", "#2E7D32"),
  lwd = c(2.5, 2, 1.8),
  lty = c(1, 2, 3),
  pch = c(19, NA, NA),
  bg = "white",
  bty = "o"
)
mtext("Nota: Eixo horizontal exibido em [0, 25], pois F(25) > 0.999999999.",
      side = 1, line = 3.8, cex = 0.8, col = "gray35")
dev.off()

# ==============================================================================
# QUESTÃO 1.5: Estimação por Máxima Verossimilhança (MLE)
# ==============================================================================
# Amostra de n = 50 observações i.i.d. de Bernoulli(p = 0.13)
# Semente fixa baseada na matrícula para garantir reprodutibilidade.
set.seed(582416)
amostra_bernoulli <- rbinom(n = n, size = 1, prob = p)

k_obs <- sum(amostra_bernoulli)
p_hat_analitico <- k_obs / n

# Função de log-verossimilhança para o modelo Binomial/Bernoulli (com constante)
log_verossimilhanca <- function(prob_val, k, n_total) {
  lchoose(n_total, k) + k * log(prob_val) + (n_total - k) * log(1 - prob_val)
}

# Verificação numérica do MLE via optimize()
otim_mle <- optimize(
  f = log_verossimilhanca,
  interval = c(1e-6, 1 - 1e-6),
  k = k_obs,
  n_total = n,
  maximum = TRUE
)
p_hat_numerico <- otim_mle$maximum

# Erro padrão teórico de p_hat para n = 50: SE(p_hat) = sqrt(p*(1-p)/n)
se_p_hat <- sqrt(p * (1 - p) / n)
erro_absoluto <- abs(p_hat_analitico - p)
erro_relativo_pct <- 100 * erro_absoluto / p

cat("====================================================================\n")
cat("QUESTAO 1.5 - ESTIMACAO POR MAXIMA VEROSSIMILHANCA (MLE)\n")
cat("====================================================================\n")
cat(sprintf("Semente utilizada               : %d\n", 582416))
cat(sprintf("Numero de sucessos observados k : %d de %d\n", k_obs, n))
cat(sprintf("p teorico                       : %.6f\n", p))
cat(sprintf("p_hat (MLE analitico = k / n)   : %.6f\n", p_hat_analitico))
cat(sprintf("p_hat (MLE numerico optimize()) : %.6f\n", p_hat_numerico))
cat(sprintf("Desvio absoluto |p_hat - p|     : %.6f\n", erro_absoluto))
cat(sprintf("Desvio relativo                 : %.2f%%\n", erro_relativo_pct))
cat(sprintf("Erro padrao teorico SE(p_hat)   : %.6f\n\n", se_p_hat))

# Gráfico 3: Curva da log-verossimilhança l(p | k)
p_grid <- seq(0.01, 0.50, length.out = 500)
ll_grid <- log_verossimilhanca(p_grid, k = k_obs, n_total = n)

png(filename = file.path(output_dir, "q1_mle_loglik.png"),
    width = 1800, height = 1200, res = 220)
par(mar = c(5, 5, 4, 2) + 0.1)
plot(
  p_grid, ll_grid,
  type = "l",
  lwd = 2.5,
  col = "#1F4E79",
  xlab = "Parâmetro p",
  ylab = "Log-verossimilhança l(p | k)",
  main = sprintf("Função de Log-Verossimilhança — Amostra Bernoulli (n = %d, k = %d)",
                 n, k_obs),
  las = 1
)
grid(col = "gray85", lty = "dotted")
lines(p_grid, ll_grid, lwd = 2.5, col = "#1F4E79")
abline(v = p_hat_analitico, col = "#2E7D32", lwd = 2, lty = 2)
abline(v = p, col = "#C0392B", lwd = 2, lty = 3)
points(p_hat_analitico,
       log_verossimilhanca(p_hat_analitico, k_obs, n),
       pch = 19, cex = 1.3, col = "#2E7D32")
legend(
  "topright",
  legend = c(
    "Log-verossimilhança l(p | k)",
    sprintf("MLE: p_hat = %.4f (k = %d)", p_hat_analitico, k_obs),
    sprintf("Valor teórico: p = %.4f", p)
  ),
  col = c("#1F4E79", "#2E7D32", "#C0392B"),
  lwd = c(2.5, 2, 2),
  lty = c(1, 2, 3),
  pch = c(NA, 19, NA),
  bg = "white",
  bty = "o"
)
dev.off()

# Demonstração do efeito do tamanho amostral (consistência do MLE)
tamanhos_amostrais <- c(50L, 100L, 250L, 500L, 1000L, 5000L, 10000L)
p_hat_por_n <- numeric(length(tamanhos_amostrais))
se_por_n <- sqrt(p * (1 - p) / tamanhos_amostrais)

cat("Efeito do tamanho amostral na convergencia de p_hat:\n")
cat(sprintf("%-10s %-12s %-14s %-14s\n", "n", "p_hat", "|p_hat - p|", "SE teorico"))
for (i in seq_along(tamanhos_amostrais)) {
  ni <- tamanhos_amostrais[i]
  if (ni == n) {
    p_hat_por_n[i] <- p_hat_analitico
  } else {
    amostra_i <- rbinom(n = ni, size = 1, prob = p)
    p_hat_por_n[i] <- mean(amostra_i)
  }
  cat(sprintf("%-10d %-12.6f %-14.6f %-14.6f\n",
              ni, p_hat_por_n[i], abs(p_hat_por_n[i] - p), se_por_n[i]))
}
cat("\n")

# Gráfico 4: Efeito do tamanho amostral na estimativa MLE
png(filename = file.path(output_dir, "q1_mle_sample_size.png"),
    width = 1800, height = 1200, res = 220)
par(mar = c(5, 5, 4, 2) + 0.1)
plot(
  tamanhos_amostrais, p_hat_por_n,
  type = "b",
  log = "x",
  pch = 19,
  lwd = 2,
  col = "#1F4E79",
  ylim = c(max(0, p - 2.5 * se_por_n[1]), p + 2.5 * se_por_n[1]),
  xlab = "Tamanho amostral n (escala logarítmica)",
  ylab = "Estimativa MLE (p_hat)",
  main = "Convergência do Estimador MLE com o Aumento do Tamanho Amostral",
  las = 1
)
grid(col = "gray85", lty = "dotted")
lines(tamanhos_amostrais, p + 1.96 * se_por_n, col = "#7F8C8D", lty = 2, lwd = 1.5)
lines(tamanhos_amostrais, p - 1.96 * se_por_n, col = "#7F8C8D", lty = 2, lwd = 1.5)
abline(h = p, col = "#C0392B", lwd = 2, lty = 1)
lines(tamanhos_amostrais, p_hat_por_n, type = "b", pch = 19, lwd = 2, col = "#1F4E79")
legend(
  "topright",
  legend = c(
    "Estimativa MLE (p_hat)",
    sprintf("Parâmetro teórico p = %.2f", p),
    "Banda assintótica p +/- 1.96 * SE(p_hat)"
  ),
  col = c("#1F4E79", "#C0392B", "#7F8C8D"),
  lwd = c(2, 2, 1.5),
  lty = c(1, 1, 2),
  pch = c(19, NA, NA),
  bg = "white",
  bty = "o"
)
dev.off()

# ==============================================================================
# EXPORTAÇÃO DE PARÂMETROS PARA AS QUESTÕES 2, 3 E 4
# ==============================================================================
q1_params <- list(
  M = M,
  p = p,
  n = n,
  m = m,
  var_X = Var_X_teorico,
  c = c_param,
  r = r_param,
  prob_ge_20 = prob_ge_20,
  prob_30_to_43 = prob_30_to_43,
  prob_eq_31 = prob_eq_31,
  mle_seed = 582416L,
  mle_k_obs = k_obs,
  mle_p_hat = p_hat_analitico
)

saveRDS(q1_params, file = file.path(output_dir, "q1_parameters.rds"))

q1_params_df <- data.frame(
  parametro = names(q1_params),
  valor = unlist(q1_params),
  row.names = NULL
)
write.csv(q1_params_df,
          file = file.path(output_dir, "q1_parameters.csv"),
          row.names = FALSE)

cat("====================================================================\n")
cat("ARQUIVOS GERADOS COM SUCESSO EM:", normalizePath(output_dir), "\n")
cat("====================================================================\n")
