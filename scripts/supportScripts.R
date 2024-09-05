# This R script contains all the functions to support README.qmd

twoWLMERMANOVA <- function(metadata, dataframe) {
        
        stat.results <- data.frame(
                variable=character(),
                term=character(),
                test=character(),
                p.value=character(),
                eff.size=character(),
                estimate=numeric(),
                contrast=character()
        )        
        
        #Determine if non-parametric
        for (catIdx in seq_along(metadata$category)) {
                category<-metadata$category[catIdx]
                variable<-metadata$variable[catIdx]
                cat(paste0("Category is: ", category,
                           "; Variable is: ", variable,
                           "\n"))
                variable_list <- c(
                        "variable","term","test",
                        "p.value","eff.size","estimate","contrast"
                )
                #filter out site=="MP" if not PA/NA
                if(!variable %in% c("PosAff","NegAff")){
                        temp_dataframe <- dataframe |>
                                #filter out MP site if not PA/NA
                                dplyr::filter(!site == "MP")
                } else {
                        temp_dataframe <- dataframe
                }
                
                #check normality for interval data first
                if (category=="interval"){
                        #lme model formula
                        lme.model.formula<-as.formula(
                                paste0(variable,
                                       " ~ (1|pID) + site * condition"))
                        cat("Two-Way Mixed Effects Repeated Measures Formula: \n")
                        print(lme.model.formula)
                        
                        #interval lme model
                        lme.model <- lmerTest::lmer(
                                lme.model.formula,
                                data = temp_dataframe,
                                contrasts = list(
                                        site = "contr.sum",
                                        condition = "contr.sum"
                                )
                        )
                        
                        lme.model.eff<-omega_squared(lme.model)
                        
                        #check for normality
                        int.norm <- broom::tidy(
                                shapiro.test(
                                        x = residuals(object = lme.model)
                                        )
                                ) |>
                                dplyr::mutate(
                                        test=method,
                                        term="Residuals",
                                        eff.size=NA,
                                        variable=variable,
                                        estimate=NA,
                                        contrast=NA
                                        ) |>
                                dplyr::select(all_of(variable_list))
                        
                        #print(int.norm)
                        stat.results<-rbind(stat.results,int.norm)
                        
                        
                        if (int.norm$p.value<0.05) {
                                cat(paste0(variable, 
                                           " is non-normal: p<0.05 (p=", 
                                           int.norm$p.value, ")"))
                                #non-parametric computation is in the next block
                        }
                }
                
                #if categorical or when normality is not met
                if (category=="categorical" || int.norm$p.value<0.05) {
                        #lme model formula
                        model.formula<-as.formula(
                                paste0("rank(",variable,")",
                                       " ~ (1|pID) + site * condition"))
                        cat("Two-Way Mixed Effects Repeated Measures Formula: \n")
                        print(model.formula)
                        
                        lme.model <- lmerTest::lmer(
                                model.formula,
                                data = temp_dataframe,
                                contrasts = list(
                                        site = "contr.sum",
                                        condition = "contr.sum"
                                )
                        )
                        lme.model.eff<-omega_squared(lme.model)
                }
                
                # After fitting the lme.model, calculate contrasts
                contrasts <- emmeans(lme.model, specs = c("site", "condition"))
                site_contrasts <- contrast(contrasts, method = "pairwise", by = "condition")
                condition_contrasts <- contrast(contrasts, method = "pairwise", by = "site")
                
                
                #extract fixed effect estimates
                print(lme4::fixef(lme.model))
                
                #compute lme model using Type 3 ANOVA
                lme.model.anova3<-car::Anova(lme.model,type=3)
                #lme.model.main<-broom::tidy(lme.model.anova3)
                
                lme.model.main <- broom::tidy(lme.model.anova3) |>
                        dplyr::filter(!term == "(Intercept)") |>
                        dplyr::select(term, statistic, p.value) |>
                        cbind(lme.model.eff$Omega2_partial) |>
                        dplyr::mutate(
                                test = ifelse(category == "categorical" || 
                                                      int.norm$p.value < 0.05,
                                              "2ME-RT-RMANOVA",
                                              "2ME-RMANOVA"),
                                eff.size = `lme.model.eff$Omega2_partial`,
                                variable = variable,
                                estimate = NA,
                                contrast = NA
                        ) |>
                        dplyr::select(all_of(variable_list))
                
                #p.val of interaction effect
                interaction.p.val<-lme.model.main[
                        lme.model.main$term=="site:condition",]$p.value
                
                #combine effect size and p val
                # lme.model.main <- lme.model.main |> 
                #         dplyr::filter(!term=="(Intercept)") |>
                #         dplyr::select(term,p.value) |>
                #         cbind(lme.model.eff$Omega2_partial) |>
                #         dplyr::mutate(
                #                 test=ifelse(category=="categorical" || 
                #                                     int.norm$p.value<0.05,
                #                             "2ME-RT-RMANOVA",
                #                             "2ME-RMANOVA"),
                #                 eff.size=`lme.model.eff$Omega2_partial`,
                #                 variable=variable) |>
                #         dplyr::select(all_of(variable_list))
                
                # # Add contrast estimates to lme.model.main
                # site_estimates <- summary(site_contrasts) %>%
                #         group_by(condition) %>%
                #         summarise(estimate = estimate[1], contrast = contrast[1], .groups = "drop") %>%
                #         mutate(term = "site") #|>
                #         #dplyr::select(!condition)
                # 
                # condition_estimates <- summary(condition_contrasts) %>%
                #         group_by(site) %>%
                #         summarise(estimate = estimate[1], contrast = contrast[1], .groups = "drop") %>%
                #         mutate(term = "condition") #|>
                #         #dplyr::select(!site)
                # 
                # print(site_estimates)
                # print(condition_estimates)
                # 
                # 
                # estimates <- rbind(site_estimates, condition_estimates) 
                # 
                # lme.model.main <- lme.model.main %>%
                #         left_join(estimates, by = "term")
                # 
                # print(lme.model.main)
                # 
                # # Select final columns
                # lme.model.main <- lme.model.main %>%
                #         dplyr::select(variable, term, test, p.value, eff.size, estimate, contrast)
                
                stat.results <- rbind(stat.results,lme.model.main)
                
                #print(stat.results)
                
                #posthoc
                #if interaction effect is prominent, compute paired comparisons
                if (interaction.p.val < 0.05) {
                        cat(paste0("Interaction Effect is significant: ",
                                   "p=",
                                   round(interaction.p.val,3),
                                   " (p<0.05) \n"))
                        # Obtain estimated marginal means (EMMs)
                        lme.emmeans <- emmeans(lme.model, 
                                               ~ site * condition)
                        
                        # Conduct pairwise comparisons
                        pair_comp <- pairs(
                                lme.emmeans,
                                simple = "each",
                                adjust="Tukey"
                                )
                        
                        #holding site constant; comparing conditions
                        cond.pairs<-broom::tidy(
                                pair_comp$`simple contrasts for condition`)
                        #holding condition constant; comparing sites
                        site.pairs<-broom::tidy(
                                pair_comp$`simple contrasts for site`)
                        
                        # Add contrast estimates to condition pairs and site pairs
                        cond.pairs <- summary(condition_contrasts) |>
                                mutate(
                                        variable = variable,
                                        term = paste0(contrast, " | ", site),
                                        test = "Simple Contrasts for Condition",
                                        eff.size = (estimate / sqrt(sum(as.data.frame(VarCorr(lme.model))$vcov)))
                                ) %>%
                                dplyr::select(variable, term, test, p.value, eff.size, estimate, contrast)
                        
                        site.pairs <- summary(site_contrasts) |>
                                mutate(
                                        variable = variable,
                                        term = paste0(contrast, " | ", condition),
                                        test = "Simple Contrasts for Site",
                                        eff.size = (estimate / sqrt(sum(as.data.frame(VarCorr(lme.model))$vcov)))
                                ) %>%
                                dplyr::select(variable, term, test, p.value, eff.size, estimate, contrast)
                        
                        # #effect size computation
                        # totSD<-sqrt(
                        #         sum(as.data.frame(
                        #                 nlme::VarCorr(lme.model))$vcov)
                        # )
                        # 
                        # cond.eff<-as.data.frame(as.emm_list(eff_size(
                        #         pair_comp$`simple contrasts for condition`,
                        #         sigma=totSD,
                        #         edf=Inf,
                        #         method = "identity")))
                        # 
                        # site.eff<-as.data.frame(as.emm_list(eff_size(
                        #         pair_comp$`simple contrasts for site`,
                        #         sigma=totSD,
                        #         edf=Inf,
                        #         method = "identity")))
                        # 
                        # cond.pairs <- cond.pairs |>
                        #         cbind(cond.eff$effect.size) |>
                        #         dplyr::mutate(
                        #                 term = paste0(contrast, " | ", site),
                        #                 test = "Simple Contrasts for Condition",
                        #                 eff.size = `cond.eff$effect.size`,
                        #                 variable = variable
                        #                 ) |>       
                        #         dplyr::select(all_of(variable_list))
                        # 
                        # site.pairs <- site.pairs |>
                        #         cbind(site.eff$effect.size) |>
                        #         dplyr::mutate(
                        #                 term = paste0(contrast," | ",condition),
                        #                 test = "Simple Contrasts for Site",
                        #                 eff.size = `site.eff$effect.size`,
                        #                 variable = variable)
                        
                        #str(site.pairs)
                        
                        # if (variable %in% c("PosAff","NegAff")) {
                        #         site.pairs<-site.pairs |>
                        #                 dplyr::mutate(p.value=adj.p.value) |>
                        #                 dplyr::select(all_of(variable_list))
                        # } else {
                        #         site.pairs <- site.pairs |> 
                        #                 dplyr::select(all_of(variable_list))
                        # }        
                        
                        
                        #print(rbind(cond.pairs,site.pairs))
                        
                        stat.results <- rbind(
                                stat.results,
                                cond.pairs,site.pairs)
                        
                        #print(stat.results)
                        
                }
                
        }
        
        return(stat.results)
}