library(faux)
library(tidyverse)
library(patchwork)
faux_options(plot = FALSE)
set.seed(8675309)

wide <- sim_design(
  within= list(
    dv = c("RT", "acc"),
    type = c("cong", "incon")),
  between = list(language = c("mono", "bi")),
  n = list(mono = 55, bi = 45),
  mu = data.frame(
    row.names = c("mono", "bi"),
    RT_cong = c(350, 360),
    RT_incon = c(600, 450),
    acc_cong = c(0, 0), # will convert to binomial later
    acc_incon = c(0, 0) # will convert to binomial later
  ),
  sd = c(50, 50, 1, 1, 50,  50, 1, 1),
      # RTi, a_c, a_i
  r = c( .5,  .6,  .3, # RTc
              .4,  .5, # RTi
                   .6) # a_c
) %>%
  mutate(
    acc_cong = norm2binom(acc_cong, size = 100, prob = .95),
    acc_incon = norm2binom(acc_incon, size = 100, prob = .85),
    # generate age with correlations to RT and none to acc
    age = rnorm_pre(data.frame(RT_cong, RT_incon, acc_cong, acc_incon), 
                    mu = 25, sd = 10, r = c(0.3, 0.3, 0, 0)),
    # truncate and round ages
    age = norm2trunc(age, 17.51, 60.49) %>% round()
  ) %>%
  select(id, age, everything())

# some relationships change a little after conversion
check_sim_stats(wide, between = "language")

long <- pivot_longer(wide, 
                     cols = RT_cong:acc_incon, 
                     names_to = c("DV_type", "congruency"), 
                     names_sep = "_", 
                     values_to = "DV")

dat <- pivot_wider(long, names_from = DV_type, values_from = DV)


rt <- ggplot(dat, aes(congruency, RT, color = congruency)) +
  geom_violin(show.legend = FALSE) +
  stat_summary(fun.data = mean_cl_normal, size = 0.2)

acc <- ggplot(dat, aes(congruency, acc, color = congruency)) +
  geom_violin(show.legend = FALSE) +
  stat_summary(fun.data = mean_cl_normal, size = 0.2)

rt + acc + patchwork::plot_layout(guides = "collect")

age_RT <- ggplot(dat, aes(age, RT, color = congruency)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = lm, formula = y ~ x)

age_acc <- ggplot(dat, aes(age, acc, color = congruency)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = lm, formula = y ~ x)


age_RT + age_acc + patchwork::plot_layout(guides = "collect")
