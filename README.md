

# Replication Code for “AI-augmented urban soundscapes: In-situ assessment of soundscape quality and restorativeness”

The GitHub repository contains the code to replicate the analysis,
figures and tables for the paper titled: ““.

The data that support the findings of this study are openly available in
NTU research  
data repository DR-NTU (Data) at .

The subheadings in this repository follows the headings in the paper
(after the [Data Loading](#data-loading) section) for consistency.

## Initialisation

## Data Loading

First, download the RData file containing all the data tables required
to replicate all the figures, tables and analyses in this paper from the
Dataverse repository.

Load the RData file `fullData.Rdata`.

## Results

## Methods

### Design of in-situ evaluation experiment

#### Effect of order and group size

**Extended Data Table 8** Summary of exact two-sample Kolmogorov-Smirnov
tests to examine effect of order (GND–ROOF or ROOF–GND) and group size
(1 or $>1$) on each soundscape evaluation attribute (sound source
dominance, overall quality, appropriateness, loudness, ISOPL, ISOEV, and
PRSS dimensions) across each condition (AMSS and AMB). All the
$p$-values were adjusted for multiple comparisons within conditions with
the Benjamini-Hochberg (BH) method.

``` r
ks.df <- amss_insitu_participant_data |>
        dplyr::select(c(condition,partGrp,order,metadata$variable)) |>
        pivot_longer(names_to = "variable",
                     values_to = "score",
                     cols = c(dom_noise:NegAff))

ks.order.grpsize <- rbind(
        #KS Test by order
        ks.df |> 
                dplyr::group_by(condition,variable) |>
                dplyr::summarise(
                        ks_test = list(ks.test(score[order == 18],
                                               score[order == 81],
                                               exact = NULL,
                                               alternative = "two.sided")),
                        ks.pvalue = ks_test[[1]]$p.value
                ) |>
                dplyr::ungroup() |>
                dplyr::group_by(condition) |>
                dplyr::mutate(ks.padj = p.adjust(ks.pvalue, method="BH"),
                              confvar = "order"),
        #KS Test by group size
        ks.df |> 
                dplyr::group_by(condition,variable) |>
                dplyr::summarise(
                        ks_test = list(ks.test(score[partGrp == "single"],
                                               score[partGrp == "multi"],
                                               exact = NULL,
                                               alternative = "two.sided")),
                        ks.pvalue = ks_test[[1]]$p.value
                ) |>
                dplyr::ungroup() |>
                dplyr::group_by(condition) |>
                dplyr::mutate(ks.padj = p.adjust(ks.pvalue, method="BH"),
                              confvar = "group size")
        ) |>
        #add significance stars
        dplyr::mutate(
                        ks.padj=paste0(gtools::stars.pval(ks.padj),
                               formatC(ks.padj,
                                       format = "f",
                                       digits = 2))
        ) |>
        dplyr::select(!ks_test) |>
        pivot_wider(values_from = ks.padj,
                    names_from = variable,
                    id_cols = c(condition,confvar)) |>
        #reorder columns
        dplyr::select(
                dom_noise, dom_human, dom_natural, 
                PosAff, NegAff, 
                overall, appropriate, loudness, 
                ISOPL, ISOEV,
                PRSSFas, PRSSBA, PRSSCom, PRSSEC, PRSSES, confvar) |>
        dplyr::group_by(confvar) |>
        gt::gt() |>
        cols_label(
                ISOEV ~ html("<i>ISOEV</i>"),
                ISOPL ~ html("<i>ISOPL</i>"),
                NegAff ~ html("<i>NA</i>"),
                PosAff ~ html("<i>PA</i>"),
                PRSSFas ~ html("<i>PRSS</i><sub>Fas</sub>"),
                PRSSBA ~ html("<i>PRSS</i><sub>BA</sub>"),
                PRSSCom ~ html("<i>PRSS</i><sub>Com</sub>"),
                PRSSEC ~ html("<i>PRSS</i><sub>EC</sub>"),
                PRSSES ~ html("<i>PRSS</i><sub>ES</sub>"),
                appropriate ~ html("<i>APPR</i>"),
                dom_natural ~ html("<i>DOM</i><sub>Nat</sub>"),
                dom_human ~ html("<i>DOM</i><sub>Hum</sub>"),
                dom_noise ~ html("<i>DOM</i><sub>Noi</sub>"),
                loudness ~ html("<i>PLN</i>"),
                overall ~ html("<i>OSQ</i>"),
        ) 
ks.order.grpsize
```

<div>

<div id="orbckgpwoo" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#orbckgpwoo table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#orbckgpwoo thead, #orbckgpwoo tbody, #orbckgpwoo tfoot, #orbckgpwoo tr, #orbckgpwoo td, #orbckgpwoo th {
  border-style: none;
}
&#10;#orbckgpwoo p {
  margin: 0;
  padding: 0;
}
&#10;#orbckgpwoo .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#orbckgpwoo .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#orbckgpwoo .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#orbckgpwoo .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#orbckgpwoo .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#orbckgpwoo .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#orbckgpwoo .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#orbckgpwoo .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#orbckgpwoo .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#orbckgpwoo .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#orbckgpwoo .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#orbckgpwoo .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#orbckgpwoo .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#orbckgpwoo .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#orbckgpwoo .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#orbckgpwoo .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#orbckgpwoo .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#orbckgpwoo .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#orbckgpwoo .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#orbckgpwoo .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#orbckgpwoo .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#orbckgpwoo .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#orbckgpwoo .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#orbckgpwoo .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#orbckgpwoo .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#orbckgpwoo .gt_left {
  text-align: left;
}
&#10;#orbckgpwoo .gt_center {
  text-align: center;
}
&#10;#orbckgpwoo .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#orbckgpwoo .gt_font_normal {
  font-weight: normal;
}
&#10;#orbckgpwoo .gt_font_bold {
  font-weight: bold;
}
&#10;#orbckgpwoo .gt_font_italic {
  font-style: italic;
}
&#10;#orbckgpwoo .gt_super {
  font-size: 65%;
}
&#10;#orbckgpwoo .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#orbckgpwoo .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#orbckgpwoo .gt_indent_1 {
  text-indent: 5px;
}
&#10;#orbckgpwoo .gt_indent_2 {
  text-indent: 10px;
}
&#10;#orbckgpwoo .gt_indent_3 {
  text-indent: 15px;
}
&#10;#orbckgpwoo .gt_indent_4 {
  text-indent: 20px;
}
&#10;#orbckgpwoo .gt_indent_5 {
  text-indent: 25px;
}
</style>

| condition  | *DOM*<sub>Noi</sub> | *DOM*<sub>Hum</sub> | *DOM*<sub>Nat</sub> | *PA* | *NA* | *OSQ* | *APPR* | *PLN* | *ISOPL* | *ISOEV* | *PRSS*<sub>Fas</sub> | *PRSS*<sub>BA</sub> | *PRSS*<sub>Com</sub> | *PRSS*<sub>EC</sub> | *PRSS*<sub>ES</sub> |
|------------|---------------------|---------------------|---------------------|------|------|-------|--------|-------|---------|---------|----------------------|---------------------|----------------------|---------------------|---------------------|
| order      |                     |                     |                     |      |      |       |        |       |         |         |                      |                     |                      |                     |                     |
| AMB        | 1.00                | 1.00                | 1.00                | 1.00 | 1.00 | 1.00  | 1.00   | 1.00  | 1.00    | 1.00    | 1.00                 | 1.00                | 1.00                 | 1.00                | 1.00                |
| AMSS       | 0.95                | 0.83                | 0.83                | 0.83 | 0.83 | 0.83  | 0.83   | 0.83  | 0.83    | 0.83    | 0.83                 | 0.83                | 0.83                 | 0.83                | 0.83                |
| group size |                     |                     |                     |      |      |       |        |       |         |         |                      |                     |                      |                     |                     |
| AMB        | 0.98                | 0.98                | 0.98                | 0.98 | 0.96 | 0.96  | 0.98   | 0.96  | 0.98    | 0.96    | 0.98                 | 0.96                | 0.96                 | 0.98                | 0.96                |
| AMSS       | 0.75                | 0.75                | 0.94                | 0.75 | 0.75 | 0.94  | 0.75   | 0.94  | 0.75    | 0.94    | 0.80                 | 0.80                | 0.75                 | 0.75                | 0.80                |

</div>

</div>

### Participants

**Extended Data Table 10** Summary of participant demographics and
non-acoustic factors (PSS-10, WNSS, WHO-5, baseline annoyance) across
each condition (AMSS and AMB).

``` r
#custom function for ks-test between ambient and amss groups across {}
ks_test <- function(data, variable, by, ...) {
  data <- data[c(variable, by)] %>% dplyr::filter(complete.cases(.))
  ks.test(data[[variable]] ~ factor(data[[by]])) %>%
  broom::tidy()
}

amss_insitu_participant_data |>
        dplyr::select(c(condition,gender,age,pss,wnss,wbi), 
                              starts_with("annoy-")) |>
        drop_na() |>
        tbl_summary(
                by = condition,
                type = list(!c(gender) ~ 'continuous'),
                statistic = list(all_continuous() ~ "{mean} ({sd})"),
                digits = list(all_continuous() ~ c(2, 2)),
                label = list(
                        pss ~ "PSS-10",
                        wnss ~ "INS",
                        wbi ~ "WHO-5",
                        `annoy-aircraft` ~ "BA@aircraft~",
                        `annoy-mrt` ~ "BA@mrt~",
                        `annoy-consite` ~ "BA@consite~",
                        `annoy-reno` ~ "BA@reno~",
                        `annoy-traffic` ~ "BA@traffic~",
                        `annoy-animals` ~ "BA@animals~",
                        `annoy-children` ~ "BA@children~",
                        `annoy-people` ~ "BA@people~",
                        `annoy-others` ~ "BA@others~"
                        )
        ) |>
        add_p(
                test = list(
                        gender ~ "prop.test",
                        c(age,pss,wnss,wbi,
                          starts_with("annoy-")) ~ c("ks_test")
                        ),
                pvalue_fun = function(x) style_pvalue(x, digits = 2)
                ) |>
        add_overall() |>
        as_gt() |>
        text_transform(
                locations = cells_body(),
                fn = function(x) {
                        str_replace_all(x,pattern = "@",
                                        replacement = "<sub>") |>
                                str_replace_all("~","</sub>") 
                        }
                )
```

<div>

<div id="oxdgujwxyq" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#oxdgujwxyq table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#oxdgujwxyq thead, #oxdgujwxyq tbody, #oxdgujwxyq tfoot, #oxdgujwxyq tr, #oxdgujwxyq td, #oxdgujwxyq th {
  border-style: none;
}
&#10;#oxdgujwxyq p {
  margin: 0;
  padding: 0;
}
&#10;#oxdgujwxyq .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#oxdgujwxyq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#oxdgujwxyq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#oxdgujwxyq .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#oxdgujwxyq .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#oxdgujwxyq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#oxdgujwxyq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#oxdgujwxyq .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#oxdgujwxyq .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#oxdgujwxyq .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#oxdgujwxyq .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#oxdgujwxyq .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#oxdgujwxyq .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#oxdgujwxyq .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#oxdgujwxyq .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oxdgujwxyq .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#oxdgujwxyq .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#oxdgujwxyq .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#oxdgujwxyq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oxdgujwxyq .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#oxdgujwxyq .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oxdgujwxyq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#oxdgujwxyq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oxdgujwxyq .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#oxdgujwxyq .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oxdgujwxyq .gt_left {
  text-align: left;
}
&#10;#oxdgujwxyq .gt_center {
  text-align: center;
}
&#10;#oxdgujwxyq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#oxdgujwxyq .gt_font_normal {
  font-weight: normal;
}
&#10;#oxdgujwxyq .gt_font_bold {
  font-weight: bold;
}
&#10;#oxdgujwxyq .gt_font_italic {
  font-style: italic;
}
&#10;#oxdgujwxyq .gt_super {
  font-size: 65%;
}
&#10;#oxdgujwxyq .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#oxdgujwxyq .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#oxdgujwxyq .gt_indent_1 {
  text-indent: 5px;
}
&#10;#oxdgujwxyq .gt_indent_2 {
  text-indent: 10px;
}
&#10;#oxdgujwxyq .gt_indent_3 {
  text-indent: 15px;
}
&#10;#oxdgujwxyq .gt_indent_4 {
  text-indent: 20px;
}
&#10;#oxdgujwxyq .gt_indent_5 {
  text-indent: 25px;
}
</style>

<table class="gt_table" data-quarto-postprocess="true"
data-quarto-disable-processing="false" data-quarto-bootstrap="false">
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr class="header gt_col_headings">
<th id="&lt;strong&gt;Characteristic&lt;/strong&gt;"
class="gt_col_heading gt_columns_bottom_border gt_left"
data-quarto-table-cell-role="th"
scope="col"><strong>Characteristic</strong></th>
<th
id="&lt;strong&gt;Overall&lt;/strong&gt;, N = 68&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"
class="gt_col_heading gt_columns_bottom_border gt_center"
data-quarto-table-cell-role="th" scope="col"><strong>Overall</strong>, N
= 68<span class="gt_footnote_marks"
style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
<th
id="&lt;strong&gt;AMB&lt;/strong&gt;, N = 32&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"
class="gt_col_heading gt_columns_bottom_border gt_center"
data-quarto-table-cell-role="th" scope="col"><strong>AMB</strong>, N =
32<span class="gt_footnote_marks"
style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
<th
id="&lt;strong&gt;AMSS&lt;/strong&gt;, N = 36&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"
class="gt_col_heading gt_columns_bottom_border gt_center"
data-quarto-table-cell-role="th" scope="col"><strong>AMSS</strong>, N =
36<span class="gt_footnote_marks"
style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
<th
id="&lt;strong&gt;p-value&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;2&lt;/sup&gt;&lt;/span&gt;"
class="gt_col_heading gt_columns_bottom_border gt_center"
data-quarto-table-cell-role="th"
scope="col"><strong>p-value</strong><span class="gt_footnote_marks"
style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span></th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr class="odd">
<td class="gt_row gt_left" headers="label">gender</td>
<td class="gt_row gt_center" headers="stat_0"><br />
</td>
<td class="gt_row gt_center" headers="stat_1"><br />
</td>
<td class="gt_row gt_center" headers="stat_2"><br />
</td>
<td class="gt_row gt_center" headers="p.value">0.091</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">    Female</td>
<td class="gt_row gt_center" headers="stat_0">40 (59%)</td>
<td class="gt_row gt_center" headers="stat_1">21 (66%)</td>
<td class="gt_row gt_center" headers="stat_2">19 (53%)</td>
<td class="gt_row gt_center" headers="p.value"><br />
</td>
</tr>
<tr class="odd">
<td class="gt_row gt_left" headers="label">    Male</td>
<td class="gt_row gt_center" headers="stat_0">28 (41%)</td>
<td class="gt_row gt_center" headers="stat_1">11 (34%)</td>
<td class="gt_row gt_center" headers="stat_2">17 (47%)</td>
<td class="gt_row gt_center" headers="p.value"><br />
</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">age</td>
<td class="gt_row gt_center" headers="stat_0">41.75 (12.83)</td>
<td class="gt_row gt_center" headers="stat_1">42.00 (13.22)</td>
<td class="gt_row gt_center" headers="stat_2">41.53 (12.65)</td>
<td class="gt_row gt_center" headers="p.value">0.91</td>
</tr>
<tr class="odd">
<td class="gt_row gt_left" headers="label">PSS-10</td>
<td class="gt_row gt_center" headers="stat_0">0.51 (0.13)</td>
<td class="gt_row gt_center" headers="stat_1">0.51 (0.13)</td>
<td class="gt_row gt_center" headers="stat_2">0.51 (0.14)</td>
<td class="gt_row gt_center" headers="p.value">0.94</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">INS</td>
<td class="gt_row gt_center" headers="stat_0">0.67 (0.06)</td>
<td class="gt_row gt_center" headers="stat_1">0.67 (0.05)</td>
<td class="gt_row gt_center" headers="stat_2">0.67 (0.06)</td>
<td class="gt_row gt_center" headers="p.value">0.72</td>
</tr>
<tr class="odd">
<td class="gt_row gt_left" headers="label">WHO-5</td>
<td class="gt_row gt_center" headers="stat_0">0.62 (0.17)</td>
<td class="gt_row gt_center" headers="stat_1">0.59 (0.17)</td>
<td class="gt_row gt_center" headers="stat_2">0.65 (0.16)</td>
<td class="gt_row gt_center" headers="p.value">0.54</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">BA<sub>aircraft</sub></td>
<td class="gt_row gt_center" headers="stat_0">3.93 (1.39)</td>
<td class="gt_row gt_center" headers="stat_1">3.88 (1.41)</td>
<td class="gt_row gt_center" headers="stat_2">3.97 (1.38)</td>
<td class="gt_row gt_center" headers="p.value">0.82</td>
</tr>
<tr class="odd">
<td class="gt_row gt_left" headers="label">BA<sub>mrt</sub></td>
<td class="gt_row gt_center" headers="stat_0">2.35 (1.22)</td>
<td class="gt_row gt_center" headers="stat_1">2.59 (1.29)</td>
<td class="gt_row gt_center" headers="stat_2">2.14 (1.13)</td>
<td class="gt_row gt_center" headers="p.value">0.46</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">BA<sub>consite</sub></td>
<td class="gt_row gt_center" headers="stat_0">3.53 (1.30)</td>
<td class="gt_row gt_center" headers="stat_1">3.59 (1.29)</td>
<td class="gt_row gt_center" headers="stat_2">3.47 (1.32)</td>
<td class="gt_row gt_center" headers="p.value">0.80</td>
</tr>
<tr class="odd">
<td class="gt_row gt_left" headers="label">BA<sub>reno</sub></td>
<td class="gt_row gt_center" headers="stat_0">3.46 (1.34)</td>
<td class="gt_row gt_center" headers="stat_1">3.59 (1.39)</td>
<td class="gt_row gt_center" headers="stat_2">3.33 (1.31)</td>
<td class="gt_row gt_center" headers="p.value">0.59</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">BA<sub>traffic</sub></td>
<td class="gt_row gt_center" headers="stat_0">3.46 (1.20)</td>
<td class="gt_row gt_center" headers="stat_1">3.53 (1.14)</td>
<td class="gt_row gt_center" headers="stat_2">3.39 (1.27)</td>
<td class="gt_row gt_center" headers="p.value">0.90</td>
</tr>
<tr class="odd">
<td class="gt_row gt_left" headers="label">BA<sub>animals</sub></td>
<td class="gt_row gt_center" headers="stat_0">2.12 (1.10)</td>
<td class="gt_row gt_center" headers="stat_1">1.94 (1.05)</td>
<td class="gt_row gt_center" headers="stat_2">2.28 (1.14)</td>
<td class="gt_row gt_center" headers="p.value">0.28</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">BA<sub>children</sub></td>
<td class="gt_row gt_center" headers="stat_0">2.51 (1.17)</td>
<td class="gt_row gt_center" headers="stat_1">2.66 (1.21)</td>
<td class="gt_row gt_center" headers="stat_2">2.39 (1.13)</td>
<td class="gt_row gt_center" headers="p.value">0.51</td>
</tr>
<tr class="odd">
<td class="gt_row gt_left" headers="label">BA<sub>people</sub></td>
<td class="gt_row gt_center" headers="stat_0">2.34 (1.02)</td>
<td class="gt_row gt_center" headers="stat_1">2.47 (1.05)</td>
<td class="gt_row gt_center" headers="stat_2">2.22 (0.99)</td>
<td class="gt_row gt_center" headers="p.value">0.28</td>
</tr>
<tr class="even">
<td class="gt_row gt_left" headers="label">BA<sub>others</sub></td>
<td class="gt_row gt_center" headers="stat_0">2.35 (1.18)</td>
<td class="gt_row gt_center" headers="stat_1">2.38 (1.10)</td>
<td class="gt_row gt_center" headers="stat_2">2.33 (1.26)</td>
<td class="gt_row gt_center" headers="p.value">0.83</td>
</tr>
</tbody><tfoot class="gt_footnotes">
<tr class="odd">
<td colspan="5" class="gt_footnote"><span class="gt_footnote_marks"
style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span>
n (%); Mean (SD)</td>
</tr>
<tr class="even">
<td colspan="5" class="gt_footnote"><span class="gt_footnote_marks"
style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span>
4-sample test for equality of proportions without continuity correction;
Exact two-sample Kolmogorov-Smirnov test</td>
</tr>
</tfoot>
&#10;</table>

</div>

</div>
