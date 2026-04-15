# fishery_ages

Static Quarto publication of the BSAI pollock otolith report.

Published site: <https://jimianelli.github.io/fishery_ages/>

## Local render

The GitHub Pages site serves the rendered files committed under `docs/`.

```bash
quarto render
```

## Data

- `df_age.csv` is the derived analysis dataset used by the report. It contains only the columns needed for this public analysis: `YEAR`, `season`, `fmp`, `subarea`, `SEX`, `AGE`, and `LENGTH`.
- `age1986-2025.csv` contains proprietary source data and is intentionally excluded from the repository.

## Notes

- The published site is a static render of `otoliths_report.qmd`; GitHub Pages does not re-render the report.
