# ========================= current workflow portable script directory =========================
cu_script_path <- local({
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg)) return(normalizePath(sub("^--file=", "", file_arg[[1]]), winslash = "/", mustWork = FALSE))
  source_file <- tryCatch(sys.frames()[[1]]$ofile, error = function(e) NULL)
  if (!is.null(source_file) && length(source_file) && nzchar(source_file[[1]])) return(normalizePath(source_file[[1]], winslash = "/", mustWork = FALSE))
  NA_character_
})
cu_script_dir <- if (!is.na(cu_script_path)) dirname(cu_script_path) else normalizePath(getwd(), winslash = "/", mustWork = TRUE)
if (!dir.exists(cu_script_dir)) stop("R script directory does not exist: ", cu_script_dir)
setwd(cu_script_dir)
options(stringsAsFactors = FALSE, warn = 1)
# ======================= end current workflow portable script directory =======================


# ========================= current workflow mandatory Times font block =========================
.font_ok <- FALSE
if (!requireNamespace("showtext", quietly = TRUE) || !requireNamespace("sysfonts", quietly = TRUE)) {
  try(install.packages(c("showtext", "sysfonts"), repos = "https://cloud.r-project.org", quiet = TRUE), silent = TRUE)
}
if (requireNamespace("showtext", quietly = TRUE) && requireNamespace("sysfonts", quietly = TRUE)) {
  if (file.exists("/Users/mac/R/font/Times_New_Roman.ttf"))
    sysfonts::font_add(family = "times", regular = "/Users/mac/R/font/Times_New_Roman.ttf")
  if (file.exists("/Users/mac/R/font/Times_New_Roman_Bold.ttf"))
    sysfonts::font_add(family = "timesbold", regular = "/Users/mac/R/font/Times_New_Roman_Bold.ttf")
  if (file.exists("/Users/mac/R/font/Times_Bold_Italic.ttf"))
    sysfonts::font_add(family = "timesitalic", regular = "/Users/mac/R/font/Times_Bold_Italic.ttf")
  .font_ok <- all(c("times", "timesbold", "timesitalic") %in% sysfonts::font_families())
  showtext::showtext_auto()
}
base_family <- if (.font_ok) "times" else "serif"
bold_family <- if (.font_ok) "timesbold" else "serif"
italic_family <- if (.font_ok) "timesitalic" else "serif"
bold_face <- if (.font_ok) "plain" else "bold"
italic_face <- if (.font_ok) "plain" else "italic"
set.seed(123)
# ======================= end current workflow mandatory Times font block =======================

# ========================= current workflow portable script directory =========================
cu_script_path <- local({
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg)) return(normalizePath(sub("^--file=", "", file_arg[[1]]), winslash = "/", mustWork = FALSE))
  source_file <- tryCatch(sys.frames()[[1]]$ofile, error = function(e) NULL)
  if (!is.null(source_file) && length(source_file) && nzchar(source_file[[1]])) return(normalizePath(source_file[[1]], winslash = "/", mustWork = FALSE))
  NA_character_
})
cu_script_dir <- if (!is.na(cu_script_path)) dirname(cu_script_path) else normalizePath(getwd(), winslash = "/", mustWork = TRUE)
if (!dir.exists(cu_script_dir)) stop("R script directory does not exist: ", cu_script_dir)

options(stringsAsFactors = FALSE, warn = 1)
# ======================= end current workflow portable script directory =======================


# ========================= current workflow mandatory Times typography block =========================
if (!requireNamespace("showtext", quietly = TRUE) || !requireNamespace("sysfonts", quietly = TRUE)) {
  try(install.packages(c("showtext", "sysfonts"), repos = "https://cloud.r-project.org", quiet = TRUE), silent = TRUE)
}
if (!requireNamespace("showtext", quietly = TRUE) || !requireNamespace("sysfonts", quietly = TRUE)) {
  stop("Required R packages showtext and sysfonts are unavailable")
}
suppressPackageStartupMessages(library(showtext))
suppressPackageStartupMessages(library(sysfonts))
.font_ok <- FALSE
if (requireNamespace("showtext", quietly = TRUE) && requireNamespace("sysfonts", quietly = TRUE)) {
  if (file.exists("/Users/mac/R/font/Times_New_Roman.ttf"))
    sysfonts::font_add(family = "times", regular = "/Users/mac/R/font/Times_New_Roman.ttf")
  if (file.exists("/Users/mac/R/font/Times_New_Roman_Bold.ttf"))
    sysfonts::font_add(family = "timesbold", regular = "/Users/mac/R/font/Times_New_Roman_Bold.ttf")
  if (file.exists("/Users/mac/R/font/Times_Bold_Italic.ttf"))
    sysfonts::font_add(family = "timesitalic", regular = "/Users/mac/R/font/Times_Bold_Italic.ttf")
  .font_ok <- all(c("times", "timesbold", "timesitalic") %in% sysfonts::font_families())
  showtext::showtext_auto()
}
base_family <- if (.font_ok) "times" else "serif"
bold_family <- if (.font_ok) "timesbold" else "serif"
italic_family <- if (.font_ok) "timesitalic" else "serif"
bold_face <- if (.font_ok) "plain" else "bold"
italic_face <- if (.font_ok) "plain" else "italic"
set.seed(123)
# ======================= end current workflow mandatory Times typography block =======================

# current workflow mandatory publication fonts (preferred user paths with portable fallback).
# library(showtext) / font_add calls are made only when the files exist, so the script remains portable.

suppressPackageStartupMessages({

# ========================= v33 common helpers =========================
safe_library <- function(pkg, required = TRUE) {
  ok <- suppressWarnings(require(pkg, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE))
  if (!ok) {
    try(suppressWarnings(install.packages(pkg, repos = "https://cloud.r-project.org", dependencies = TRUE, quiet = TRUE)), silent = TRUE)
    ok <- suppressWarnings(require(pkg, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE))
  }
  if (!ok && required) stop(paste0("Required R package not available after install attempt: ", pkg))
  invisible(ok)
}

safe_library("ggplot2")
safe_library("dplyr")

has_ggrepel <- safe_library("ggrepel", required = FALSE)
has_openxlsx <- safe_library("openxlsx", required = FALSE)
has_showtext <- safe_library("showtext", required = FALSE)
has_sysfonts <- safe_library("sysfonts", required = FALSE)
has_ggtext <- safe_library("ggtext", required = FALSE)

first_existing <- function(paths) {
  paths <- paths[file.exists(paths)]
  if (length(paths) == 0) return(NA_character_)
  paths[1]
}

base_family <- "serif"
bold_family <- "serif"
italic_family <- "serif"
bold_face <- "bold"
italic_face <- "italic"
font_registered <- FALSE

if (has_showtext && has_sysfonts) {
  regular_font <- first_existing(c(
    "/Users/mac/R/font/Times_New_Roman.ttf",
    "/Users/mac/R/font/Times_New_Roman.ttf",
    "/Library/Fonts/Times New Roman.ttf",
    "/System/Library/Fonts/Supplemental/Times New Roman.ttf",
    "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf"
  ))
  bold_font <- first_existing(c(
    "/Users/mac/R/font/Times_New_Roman_Bold.ttf",
    "/Users/mac/R/font/Times_New_Roman_Bold.ttf",
    "/Library/Fonts/Times New Roman Bold.ttf",
    "/System/Library/Fonts/Supplemental/Times New Roman Bold.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf"
  ))
  italic_font <- first_existing(c(
    "/Users/mac/R/font/Times_Bold_Italic.ttf",
    "/Users/mac/R/font/Times_Bold_Italic.ttf",
    "/Users/mac/R/font/Times_Bold_Italic.ttf",
    "/Library/Fonts/Times New Roman Italic.ttf",
    "/System/Library/Fonts/Supplemental/Times New Roman Italic.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSerif-Italic.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSerif-Italic.ttf"
  ))

  times_ok <- FALSE; timesbold_ok <- FALSE; timesitalic_ok <- FALSE
  if (!is.na(regular_font)) times_ok <- isTRUE(tryCatch({ sysfonts::font_add(family = "times", regular = regular_font); TRUE }, error = function(e) FALSE))
  if (!is.na(bold_font)) timesbold_ok <- isTRUE(tryCatch({ sysfonts::font_add(family = "timesbold", regular = bold_font); TRUE }, error = function(e) FALSE))
  if (!is.na(italic_font)) timesitalic_ok <- isTRUE(tryCatch({ sysfonts::font_add(family = "timesitalic", regular = italic_font); TRUE }, error = function(e) FALSE))

  if (times_ok) base_family <- "times"
  if (timesbold_ok) { bold_family <- "timesbold"; bold_face <- "plain" } else if (times_ok) { bold_family <- "times"; bold_face <- "bold" }
  if (timesitalic_ok) { italic_family <- "timesitalic"; italic_face <- "plain" } else if (times_ok) { italic_family <- "times"; italic_face <- "italic" }
  font_registered <- times_ok || timesbold_ok || timesitalic_ok
  if (font_registered) try(showtext::showtext_auto(), silent = TRUE)
}

pdf_device <- if (capabilities("cairo")) grDevices::cairo_pdf else "pdf"

clean_text <- function(x) {
  x <- as.character(x)
  x <- gsub("^[[:space:]]+|[[:space:]]+$", "", x)
  x
}

# current workflow: recognize both GenBank-style accessions (e.g., PQ846489) and
# RefSeq-style accessions with an underscore (e.g., NC_063549, NC_063549.1).
# The previous pattern did not match NC_ accessions, so facet strips from
# Table5_NC_xxxxxx_COA.csv showed only the accession instead of species + accession.
accession_pattern <- "[A-Z]{1,4}_?[0-9]{5,}(?:[.][0-9]+)?"

extract_accession <- function(x) {
  x <- clean_text(x)
  vapply(x, function(z) {
    m <- regexpr(accession_pattern, z, perl = TRUE)
    if (is.na(m[1]) || m[1] < 0) "" else regmatches(z, m)[1]
  }, character(1), USE.NAMES = FALSE)
}

strip_accession <- function(x) {
  x <- clean_text(x)
  out <- gsub(paste0("[[:space:]]*", accession_pattern, "$"), "", x, perl = TRUE)
  clean_text(out)
}

read_species_name_map <- local({
  cache <- NULL
  function() {
    if (!is.null(cache)) return(cache)
    candidate_files <- unique(c(
      file.path("..", "Table1_Output", "species_name.txt"),
      file.path(getwd(), "..", "Table1_Output", "species_name.txt"),
      file.path("Table1_Output", "species_name.txt"),
      "species_name.txt"
    ))
    hit <- candidate_files[file.exists(candidate_files)]
    if (length(hit) == 0) {
      cache <<- data.frame(Accession = character(), Species_Name = character(), stringsAsFactors = FALSE)
      return(cache)
    }
    df <- tryCatch(read.delim(hit[1], header = FALSE, sep = "\t", stringsAsFactors = FALSE, quote = "", comment.char = ""), error = function(e) NULL)
    if (is.null(df) || ncol(df) < 2) {
      cache <<- data.frame(Accession = character(), Species_Name = character(), stringsAsFactors = FALSE)
      return(cache)
    }
    df <- df[, 1:2, drop = FALSE]
    names(df) <- c("Accession", "Species_Name")
    df$Accession <- clean_text(df$Accession)
    df$Species_Name <- clean_text(df$Species_Name)
    df <- df[nzchar(df$Accession) & nzchar(df$Species_Name), , drop = FALSE]
    cache <<- df
    cache
  }
})

species_display_name <- function(x) {
  x <- clean_text(x)
  acc <- extract_accession(x)
  if (!nzchar(acc) && grepl(paste0("^", accession_pattern, "$"), x, perl = TRUE)) acc <- x
  map <- read_species_name_map()
  species <- ""
  if (nrow(map) > 0 && nzchar(acc) && acc %in% map$Accession) {
    species <- map$Species_Name[match(acc, map$Accession)]
  } else {
    stripped <- strip_accession(x)
    if (nzchar(stripped) && stripped != x) species <- stripped else species <- if (nzchar(acc)) acc else x
  }
  species <- clean_text(species)
  if (nzchar(acc) && !grepl(paste0("[[:space:]]+", acc, "$"), species)) paste(species, acc) else species
}

species_display_vector <- function(x) vapply(as.character(x), species_display_name, character(1), USE.NAMES = FALSE)

species_label_markdown <- function(x) {
  x <- species_display_name(x)
  sp <- strip_accession(x)
  acc <- extract_accession(x)
  sp <- gsub("&", "&amp;", sp, fixed = TRUE)
  sp <- gsub("<", "&lt;", sp, fixed = TRUE)
  sp <- gsub(">", "&gt;", sp, fixed = TRUE)
  if (nzchar(acc)) paste0("<i>", sp, " ", acc, "</i>") else paste0("<i>", sp, "</i>")
}

species_label_markdown_vector <- function(x) vapply(as.character(x), species_label_markdown, character(1), USE.NAMES = FALSE)

# current workflow: plot labels use italic Latin species labels; accessions may be italic for visual consistency.
# Use markdown where ggtext is available; otherwise fall back to plain display labels.
species_legend_labels <- function(x) {
  if (exists("has_ggtext") && isTRUE(has_ggtext)) species_label_markdown_vector(x) else species_display_vector(x)
}

taxon_label_markdown <- function(x) {
  x <- clean_text(x)
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  paste0("<i>", x, "</i>")
}

taxon_label_markdown_vector <- function(x) vapply(as.character(x), taxon_label_markdown, character(1), USE.NAMES = FALSE)

taxon_legend_labels <- function(x) {
  if (exists("has_ggtext") && isTRUE(has_ggtext)) taxon_label_markdown_vector(x) else as.character(x)
}

make_taxon_labeller <- function(taxa) {
  exprs <- vapply(taxa, function(x) {
    x <- gsub("'", "\\'", clean_text(x))
    paste0("italic('", x, "')")
  }, character(1))
  ggplot2::as_labeller(stats::setNames(exprs, taxa), label_parsed)
}

extract_genus_one <- function(x) {
  x <- clean_text(x)
  if (!nzchar(x) || is.na(x)) return("Unknown")
  sp <- strip_accession(species_display_name(x))
  genus <- sub("[[:space:]]+.*$", "", sp)
  if (is.na(genus) || !nzchar(genus)) "Unknown" else genus
}

extract_genus <- function(x) {
  vapply(as.character(x), extract_genus_one, character(1), USE.NAMES = FALSE)
}


species_facet_display_name <- function(x) {{
  x <- species_display_name(x)
  acc <- extract_accession(x)
  sp <- strip_accession(x)
  sp <- clean_text(gsub("\\b(var\\.?|subsp\\.?|ssp\\.?|subspecies|forma|f\\.?|cv\\.?|cultivar)\\b.*$", "", sp, ignore.case = TRUE, perl = TRUE))
  tokens <- strsplit(sp, "[[:space:]]+", perl = TRUE)[[1]]
  tokens <- tokens[nzchar(tokens)]
  if (length(tokens) >= 2) sp <- paste(tokens[1:2], collapse = " ")
  if (!nzchar(sp)) sp <- strip_accession(x)
  if (nzchar(acc)) paste(sp, acc) else sp
}}
make_species_labeller <- function(species_names) {
  exprs <- vapply(species_names, function(x) {
    x <- species_facet_display_name(x)
    sp <- strip_accession(x)
    acc <- extract_accession(x)
    sp <- gsub("'", "\\'", sp)
    acc <- gsub("'", "\\'", acc)
    if (nzchar(acc)) paste0("italic('", sp, " ", acc, "')") else paste0("italic('", sp, "')")
  }, character(1))
  ggplot2::as_labeller(stats::setNames(exprs, species_names), label_parsed)
}

panel_ncol <- function(n) {
  n <- max(1, as.integer(n))
  if (n <= 1) return(1L)
  if (n <= 4) return(2L)
  if (n <= 9) return(3L)
  if (n <= 16) return(4L)
  if (n <= 25) return(5L)
  return(6L)
}

figure_dims <- function(n_panels, base_w = 4.2, base_h = 3.5, max_w = 22, max_h = 30) {
  nc <- panel_ncol(n_panels)
  nr <- ceiling(max(1, n_panels) / nc)
  c(width = min(max_w, max(7, base_w * nc)), height = min(max_h, max(5, base_h * nr)), ncol = nc, nrow = nr)
}

make_palette <- function(n) {
  base_cols <- c("#0173B2", "#DE8F05", "#029E73", "#D55E00", "#CC78BC", "#CA9161", "#56B4E9", "#E69F00", "#009E73", "#0072B2", "#CC79A7", "#3B4992", "#EE0000", "#008B45", "#631879", "#008280", "#BB0021", "#5F559B", "#A20056", "#F39800", "#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD", "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF", "#00468B", "#ED0000", "#42B540", "#0099B4", "#925E9F", "#FDAF91", "#AD002A", "#ADB6B6", "#2E86AB", "#A23B72", "#F18F01", "#C73E1D", "#4ECDC4", "#45B7D1", "#96CEB4", "#FECA57", "#7209B7", "#F72585")
  n <- max(1, as.integer(n))
  if (n <= length(base_cols)) return(base_cols[seq_len(n)])
  grDevices::colorRampPalette(base_cols)(n)
}

# current workflow: CPGView/OGDRAW-style plastome protein-coding gene functional classification.
# Codon-usage analyses (ENC-GC3s, neutrality, PR2, COA and RSCU profiles) are
# calculated from CDS/protein-coding genes. Therefore tRNA and rRNA genes are
# not used as independent legend categories in these codon-bias figures.
# If trn*/rrn* labels appear in an input table, they are conservatively routed
# to "Other/uncertain features" for QC rather than creating misleading RNA
# categories in protein-coding-gene codon-usage plots.
classify_gene_function <- function(gene_name) {
  raw_gene <- clean_text(gene_name)
  gene_name <- toupper(raw_gene)
  gene_name <- gsub("[[:space:]-]+", "_", gene_name)
  gene_name <- gsub("[^A-Z0-9_.]", "_", gene_name)
  if (is.na(gene_name) || gene_name == "" || gene_name == "NA") return("Other/uncertain features")

  # Non-coding RNA genes are not valid protein-coding targets for codon-usage
  # statistics. Keep them out of the figure legend while retaining a QC class.
  if (grepl("^(TRN|TRNA)|TRNA|TRANSFER_RNA|T_RNA", gene_name)) return("Other/uncertain features")
  if (grepl("^(RRN|RRNA)|RIBOSOMAL_RNA|(^|_)16S($|_)|(^|_)23S($|_)|(^|_)4[.]?5S($|_)|(^|_)5S($|_)", gene_name)) return("Other/uncertain features")

  if (grepl("^PSA", gene_name)) return("Photosystem I")
  if (grepl("^PSB|^PBF1", gene_name)) return("Photosystem II")
  if (grepl("^PET", gene_name)) return("Cytochrome b6/f complex")
  if (grepl("^ATP", gene_name)) return("ATP synthase")
  if (grepl("^NDH", gene_name)) return("NADH dehydrogenase")
  if (grepl("^RBCL$|^RBCL", gene_name)) return("Rubisco large subunit")
  if (grepl("^RPO", gene_name)) return("RNA polymerase")
  if (grepl("^RPS", gene_name)) return("Small ribosomal proteins")
  if (grepl("^RPL", gene_name)) return("Large ribosomal proteins")

  if (grepl("^(MATK|CLPP|INFA|ACCD|CEMA|CCSA|TUFA|YCF3|YCF4|TIC214|PAFA|PAFB|CHLB|CHLL|CHLN|CHLI|FTSI|FTSW|MIND|CYSA|CYST)$", gene_name)) {
    return("Other conserved genes")
  }

  if (grepl("^YCF|^ORF|HYPOTHETICAL|OPEN_READING_FRAME|UNKNOWN", gene_name)) return("Hypothetical reading frame")
  "Other/uncertain features"
}

gene_function_levels <- c(
  "Photosystem I", "Photosystem II", "Cytochrome b6/f complex", "ATP synthase",
  "NADH dehydrogenase", "Rubisco large subunit", "RNA polymerase",
  "Small ribosomal proteins", "Large ribosomal proteins", "Other conserved genes",
  "Hypothetical reading frame", "Other/uncertain features"
)

# current workflow: three journal-style palettes adapted from the user-provided Fig2/Fig3/Fig4
# Nature/Cell/Science colour schemes. These palettes share the same biological
# categories so the legend remains consistent across all codon-bias figures.
gene_function_palettes <- list(
  Nature = c(
    "Photosystem I" = "#005F73",
    "Photosystem II" = "#0A9396",
    "Cytochrome b6/f complex" = "#94D2BD",
    "ATP synthase" = "#E9D8A6",
    "NADH dehydrogenase" = "#EE9B00",
    "Rubisco large subunit" = "#CA6702",
    "RNA polymerase" = "#BB3E03",
    "Small ribosomal proteins" = "#AE2012",
    "Large ribosomal proteins" = "#9B2226",
    "Other conserved genes" = "#577590",
    "Hypothetical reading frame" = "#6D597A",
    "Other/uncertain features" = "#8A8F98"
  ),
  Cell = c(
    "Photosystem I" = "#264653",
    "Photosystem II" = "#2A9D8F",
    "Cytochrome b6/f complex" = "#8AB17D",
    "ATP synthase" = "#E9C46A",
    "NADH dehydrogenase" = "#F4A261",
    "Rubisco large subunit" = "#E76F51",
    "RNA polymerase" = "#D62828",
    "Small ribosomal proteins" = "#9D4EDD",
    "Large ribosomal proteins" = "#5A189A",
    "Other conserved genes" = "#457B9D",
    "Hypothetical reading frame" = "#6C757D",
    "Other/uncertain features" = "#A8A29E"
  ),
  Science = c(
    "Photosystem I" = "#0072B2",
    "Photosystem II" = "#009E73",
    "Cytochrome b6/f complex" = "#56B4E9",
    "ATP synthase" = "#E69F00",
    "NADH dehydrogenase" = "#D55E00",
    "Rubisco large subunit" = "#F0E442",
    "RNA polymerase" = "#CC79A7",
    "Small ribosomal proteins" = "#999999",
    "Large ribosomal proteins" = "#000000",
    "Other conserved genes" = "#7F3C8D",
    "Hypothetical reading frame" = "#11A579",
    "Other/uncertain features" = "#A6A6A6"
  )
)

select_gene_function_palette <- function() {
  palette_name <- Sys.getenv("CODON_GENE_FUNCTION_PALETTE", unset = "Nature")
  if (!palette_name %in% names(gene_function_palettes)) {
    warning(paste0("Unknown CODON_GENE_FUNCTION_PALETTE='", palette_name,
                   "'. Using Nature palette. Valid values: ",
                   paste(names(gene_function_palettes), collapse = ", ")))
    palette_name <- "Nature"
  }
  gene_function_palettes[[palette_name]][gene_function_levels]
}

gene_function_colors <- select_gene_function_palette()

write_gene_function_classification_audit <- function(file = "Gene_Function_Classification_Audit_.tsv") {
  audit <- data.frame(
    Order = seq_along(gene_function_levels),
    Category = gene_function_levels,
    Nature = unname(gene_function_palettes$Nature[gene_function_levels]),
    Cell = unname(gene_function_palettes$Cell[gene_function_levels]),
    Science = unname(gene_function_palettes$Science[gene_function_levels]),
    Rule = c(
      "Genes beginning with psa",
      "Genes beginning with psb or pbf1",
      "Genes beginning with pet",
      "Genes beginning with atp",
      "Genes beginning with ndh",
      "rbcL",
      "Genes beginning with rpo",
      "Genes beginning with rps",
      "Genes beginning with rpl",
      "matK, clpP, infA, accD, cemA, ccsA, tufA, ycf3, ycf4, tic214, pafA/pafB, chlB/chlL/chlN/chlI, ftsI/ftsW, minD, cysA/cysT",
      "ycf genes except ycf3/ycf4, orf, hypothetical/open reading frame",
      "Unclassified labels and non-coding RNA labels detected in CDS-derived codon-usage tables"
    ),
    Note = c(
      "Photosystem I protein-coding genes",
      "Photosystem II protein-coding genes",
      "Cytochrome b6/f complex protein-coding genes",
      "ATP synthase protein-coding genes",
      "NADH dehydrogenase protein-coding genes",
      "Rubisco large subunit protein-coding gene",
      "Plastid-encoded RNA polymerase protein-coding genes",
      "Small ribosomal protein-coding genes",
      "Large ribosomal protein-coding genes",
      "Conserved plastome protein-coding genes not assigned to the above complexes",
      "Putative or less-characterized open reading frame genes",
      "tRNA/rRNA genes are non-coding and are not shown as separate codon-usage legend categories"
    ),
    stringsAsFactors = FALSE
  )
  try(utils::write.table(audit, file = file, sep = "	", quote = FALSE, row.names = FALSE), silent = TRUE)
  invisible(audit)
}
try(write_gene_function_classification_audit(), silent = TRUE)



detect_gene_col <- function(df) {
  candidates <- c("gene_name", "Gene", "gene", "Gene_name", "GENE", "GeneID")
  hit <- candidates[candidates %in% names(df)]
  if (length(hit) == 0) return(NA_character_)
  hit[1]
}

to_num <- function(x) suppressWarnings(as.numeric(as.character(x)))

read_indexed_files <- function(data_files, species_names) {
  out <- list()
  for (i in seq_along(data_files)) {
    if (!file.exists(data_files[i])) { warning(paste("Missing input file:", data_files[i])); next }
    df <- tryCatch(read.csv(data_files[i], stringsAsFactors = FALSE, check.names = FALSE), error = function(e) NULL)
    if (is.null(df) || nrow(df) == 0) { warning(paste("Failed or empty input file:", data_files[i])); next }
    df$Species <- species_names[i]
    df$Source_File <- basename(data_files[i])
    out[[length(out) + 1]] <- df
  }
  if (length(out) == 0) stop("No valid input files were loaded.")
  dplyr::bind_rows(out)
}

add_gene_metadata <- function(df) {
  gene_col <- detect_gene_col(df)
  if (is.na(gene_col)) df$Gene_Label <- ifelse("Codon" %in% names(df), as.character(df$Codon), as.character(seq_len(nrow(df)))) else df$Gene_Label <- clean_text(df[[gene_col]])
  df$Gene_Function <- factor(vapply(df$Gene_Label, classify_gene_function, character(1)), levels = gene_function_levels)
  df
}

xlsx_column_is_species_or_gene <- function(header) {
  h <- tolower(clean_text(header))
  any(grepl("species|gene", h))
}


clean_table_title <- function(title, file = NULL) {
  title <- clean_text(title)
  if (!nzchar(title) && !is.null(file)) return(table_title_from_file(file))
  title <- gsub("_", " ", title, fixed = TRUE)
  title <- sub("^Fig1 RSCU summary$", "Supplementary Table. Summary of relative synonymous codon usage (RSCU) across species", title)
  title <- sub("^Fig2 ENC GC3s summary$", "Supplementary Table. Summary of ENC-GC3s analysis of codon usage bias", title)
  title <- sub("^Fig3 Neutrality regression summary$", "Supplementary Table. Regression summary of neutrality plot analysis", title)
  title <- sub("^Fig4 PR2 quadrant summary$", "Supplementary Table. PR2 quadrant summary of codon usage bias", title)
  title <- sub("^Fig5 COA scores$", "Supplementary Table. Gene scores from correspondence analysis of codon usage", title)
  title <- sub("^Fig5 COA axis summary$", "Supplementary Table. Axis summary of correspondence analysis", title)
  title <- sub("^Fig6 RSCU heatmap long$", "Supplementary Table. Long-format RSCU values used for heatmap construction", title)
  title <- sub("^Supplementary Table RSCU heatmap long-format data$", "Supplementary Table. Long-format RSCU values used for heatmap construction", title)
  title <- sub("^(Supplementary Table S[0-9]+)([[:alpha:]]*)[[:space:]]+", "\\1\\2. ", title, perl = TRUE)
  title <- gsub("Whole genome", "Whole-genome", title, ignore.case = FALSE)
  title <- gsub("ENC-GC3s", "ENC-GC3s", title, fixed = TRUE)
  title
}

table_title_from_file <- function(file) {
  b <- basename(file)
  if (grepl("Fig1_RSCU_summary[.]xlsx$", b)) return("Supplementary Table. Summary of relative synonymous codon usage (RSCU) across species")
  if (grepl("Fig2_ENC_GC3s_summary[.]xlsx$", b)) return("Supplementary Table. Summary of ENC-GC3s analysis of codon usage bias")
  if (grepl("Fig3_Neutrality_regression_summary[.]xlsx$", b)) return("Supplementary Table. Regression summary of neutrality plot analysis")
  if (grepl("Fig4_PR2_quadrant_summary[.]xlsx$", b)) return("Supplementary Table. PR2 quadrant summary of codon usage bias")
  if (grepl("Fig5_COA_scores[.]xlsx$", b)) return("Supplementary Table. Gene scores from correspondence analysis of codon usage")
  if (grepl("Fig5_COA_axis_summary[.]xlsx$", b)) return("Supplementary Table. Axis summary of correspondence analysis")
  if (grepl("Fig6_RSCU_heatmap_long[.]xlsx$", b)) return("Supplementary Table. Long-format RSCU values used for heatmap construction")
  clean_table_title(sub("[.]xlsx$", "", b), file = NULL)
}

table_note_from_file <- function(file) {
  b <- basename(file)
  if (grepl("Fig1_RSCU", b)) return("Note: RSCU denotes relative synonymous codon usage. Values >1 indicate preferentially used codons within the corresponding synonymous codon family. Latin species names and gene symbols are italicized where supported by XLSX rendering.")
  if (grepl("Fig2_ENC", b)) return("Note: ENC denotes the effective number of codons and GC3s denotes GC content at synonymous third codon positions. The Wright expected ENC curve is used for interpretation. Latin species names and gene symbols are italicized where supported by XLSX rendering.")
  if (grepl("Fig3_Neutrality", b)) return("Note: GC12 is the mean GC content at the first and second codon positions, and GC3 is the GC content at the third codon position. Regression statistics are shown only when sufficient variable data are available.")
  if (grepl("Fig4_PR2", b)) return("Note: PR2 denotes parity rule 2 analysis. Quadrants summarize A/T and G/C compositional bias at the third codon position.")
  if (grepl("Fig5_COA", b)) return("Note: COA denotes correspondence analysis. Axis scores summarize major trends in codon usage variation. Gene symbols are italicized where supported by XLSX rendering.")
  if (grepl("Fig6_RSCU", b)) return("Note: This table contains long-format RSCU values used to draw the heatmap. Latin species names and codon/gene labels are italicized where supported by XLSX rendering.")
  "Note: Latin species names and gene symbols are italicized where supported by XLSX rendering. ENC, effective number of codons; RSCU, relative synonymous codon usage; PR2, parity rule 2; COA, correspondence analysis."
}

write_optional_xlsx <- function(df, file, title = NULL, note = NULL) {
  if (!has_openxlsx) return(invisible(FALSE))
  tryCatch({
    wb <- openxlsx::createWorkbook()
    openxlsx::addWorksheet(wb, "Table")
    if (is.null(title) || !nzchar(clean_text(title))) title <- table_title_from_file(file) else title <- clean_table_title(title, file)
    if (is.null(note) || !nzchar(clean_text(note))) note <- table_note_from_file(file)
    ncol_df <- max(1, ncol(df)); nrow_df <- nrow(df)
    openxlsx::writeData(wb, "Table", title, startRow = 1, startCol = 1)
    if (ncol_df > 1) openxlsx::mergeCells(wb, "Table", cols = 1:ncol_df, rows = 1)
    title_style <- openxlsx::createStyle(fontName = "Times New Roman", fontSize = 12, textDecoration = "bold", halign = "center", valign = "center", wrapText = TRUE)
    header_style <- openxlsx::createStyle(fontName = "Times New Roman", fontSize = 11, textDecoration = "bold", halign = "center", valign = "center", border = c("top", "bottom"), borderStyle = c("medium", "thin"), wrapText = TRUE)
    body_style <- openxlsx::createStyle(fontName = "Times New Roman", fontSize = 10, halign = "center", valign = "center", wrapText = TRUE)
    italic_style <- openxlsx::createStyle(fontName = "Times New Roman", fontSize = 10, textDecoration = "italic", halign = "center", valign = "center", wrapText = TRUE)
    bottom_style <- openxlsx::createStyle(fontName = "Times New Roman", fontSize = 10, halign = "center", valign = "center", border = "bottom", borderStyle = "medium", wrapText = TRUE)
    note_style <- openxlsx::createStyle(fontName = "Times New Roman", fontSize = 10, textDecoration = "italic", halign = "left", valign = "top", wrapText = TRUE)
    openxlsx::addStyle(wb, "Table", title_style, rows = 1, cols = 1, gridExpand = TRUE, stack = TRUE)
    openxlsx::writeData(wb, "Table", df, startRow = 2, startCol = 1, withFilter = FALSE)
    openxlsx::addStyle(wb, "Table", header_style, rows = 2, cols = 1:ncol_df, gridExpand = TRUE, stack = TRUE)
    if (nrow_df > 0) openxlsx::addStyle(wb, "Table", body_style, rows = 3:(nrow_df + 2), cols = 1:ncol_df, gridExpand = TRUE, stack = TRUE)
    ital_cols <- which(vapply(names(df), xlsx_column_is_species_or_gene, logical(1)))
    if (length(ital_cols) > 0 && nrow_df > 0) openxlsx::addStyle(wb, "Table", italic_style, rows = 3:(nrow_df + 2), cols = ital_cols, gridExpand = TRUE, stack = TRUE)
    if (nrow_df > 0) openxlsx::addStyle(wb, "Table", bottom_style, rows = nrow_df + 2, cols = 1:ncol_df, gridExpand = TRUE, stack = TRUE)
    note_row <- nrow_df + 4
    openxlsx::writeData(wb, "Table", note, startRow = note_row, startCol = 1)
    if (ncol_df > 1) openxlsx::mergeCells(wb, "Table", cols = 1:ncol_df, rows = note_row)
    openxlsx::addStyle(wb, "Table", note_style, rows = note_row, cols = 1, stack = TRUE)
    openxlsx::setColWidths(wb, "Table", cols = 1:ncol_df, widths = "auto")
    openxlsx::saveWorkbook(wb, file, overwrite = TRUE)
    invisible(TRUE)
  }, error = function(e) { warning(paste("Could not write XLSX", file, e$message)); invisible(FALSE) })
}

gene_label_size <- function(n_points) {
  n_points <- max(1, as.integer(n_points))
  if (n_points <= 25) return(3.25)
  if (n_points <= 60) return(2.95)
  if (n_points <= 150) return(2.60)
  if (n_points <= 350) return(2.35)
  return(2.10)
}

smart_label_limit <- function(n_rows, n_groups = 1L) {
  n_rows <- max(1L, as.integer(n_rows))
  n_groups <- max(1L, as.integer(n_groups))
  if (n_rows <= 30) return(30L)        # very small datasets: label all points
  if (n_rows <= 80) return(12L)        # small panels: label key genes only
  if (n_rows <= 200) return(9L)
  if (n_rows <= 500) return(7L)
  return(5L)
}

select_gene_label_data <- function(df, xvar, yvar, per_species_limit = NULL, global_all_limit = NULL) {
  if (!('Gene_Label' %in% names(df))) return(df[0, , drop = FALSE])
  df <- df[is.finite(df[[xvar]]) & is.finite(df[[yvar]]) & nzchar(as.character(df$Gene_Label)), , drop = FALSE]
  if (nrow(df) == 0) return(df)
  split_var <- if ('Species' %in% names(df)) as.character(df$Species) else rep('All', nrow(df))
  n_groups <- length(unique(split_var))
  auto_limit <- smart_label_limit(nrow(df), n_groups)
  if (is.null(per_species_limit) || !is.finite(per_species_limit)) {
    per_species_limit <- auto_limit
  } else {
    per_species_limit <- min(as.integer(per_species_limit), auto_limit)
  }
  if (is.null(global_all_limit) || !is.finite(global_all_limit)) {
    global_all_limit <- max(25L, min(90L, per_species_limit * n_groups))
  } else {
    global_all_limit <- min(as.integer(global_all_limit), max(25L, per_species_limit * n_groups))
  }
  if (nrow(df) <= min(30L, global_all_limit)) return(df)
  parts <- lapply(split(df, split_var, drop = TRUE), function(z) {
    if (nrow(z) == 0) return(z)
    sx <- stats::sd(z[[xvar]], na.rm = TRUE); sy <- stats::sd(z[[yvar]], na.rm = TRUE)
    if (!is.finite(sx) || sx == 0) sx <- 0.001
    if (!is.finite(sy) || sy == 0) sy <- 0.001
    score <- abs(z[[xvar]] - stats::median(z[[xvar]], na.rm = TRUE)) / sx +
      abs(z[[yvar]] - stats::median(z[[yvar]], na.rm = TRUE)) / sy
    # Prefer genes away from the central cluster, and keep deterministic ordering.
    z$.__label_score <- score
    z <- z[order(-z$.__label_score, as.character(z$Gene_Label)), , drop = FALSE]
    z <- utils::head(z, min(nrow(z), as.integer(per_species_limit)))
    z$.__label_score <- NULL
    z
  })
  out <- dplyr::bind_rows(parts)
  if (nrow(out) > global_all_limit) {
    sx <- stats::sd(df[[xvar]], na.rm = TRUE); sy <- stats::sd(df[[yvar]], na.rm = TRUE)
    if (!is.finite(sx) || sx == 0) sx <- 0.001
    if (!is.finite(sy) || sy == 0) sy <- 0.001
    out$.__label_score <- abs(out[[xvar]] - stats::median(df[[xvar]], na.rm = TRUE)) / sx +
      abs(out[[yvar]] - stats::median(df[[yvar]], na.rm = TRUE)) / sy
    out <- out[order(-out$.__label_score, as.character(out$Gene_Label)), , drop = FALSE]
    out <- utils::head(out, global_all_limit)
    out$.__label_score <- NULL
  }
  out
}

journal_theme <- function(base_size = 11) {
  theme_bw(base_family = base_family, base_size = base_size) +
    theme(
      plot.title = element_text(family = bold_family, face = bold_face, hjust = 0.5, colour = "black", size = base_size * 1.35),
      axis.title = element_text(family = bold_family, face = bold_face, colour = "black", size = base_size * 1.18),
      axis.text = element_text(family = base_family, colour = "black", size = base_size * 1.00),
      strip.text = element_text(family = italic_family, face = italic_face, colour = "black", size = base_size * 0.93),
      strip.background = element_rect(fill = "white", colour = "black", linewidth = 0.6),
      panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.85),
      panel.grid.major = element_line(colour = "grey88", linewidth = 0.25),
      panel.grid.minor = element_blank(),
      legend.title = element_text(family = bold_family, face = bold_face, size = base_size * 1.5),
      legend.text = if (exists("has_ggtext") && isTRUE(has_ggtext)) ggtext::element_markdown(family = base_family, size = base_size * 1.2) else element_text(family = base_family, size = base_size * 0.98),
      legend.key.size = grid::unit(0.55, "cm"),
      plot.background = element_rect(fill = "white", colour = NA),
      panel.background = element_rect(fill = "white", colour = NA)
    )
}
# ======================= end v33 common helpers =======================

})

set.seed(123)

species_names <- c("Medicago truncatula f. tricycla KF241982", "Medicago hybrida KJ850240", "Medicago papillosa KJ850241", "Medicago archiducis-nicolai MN901634", "Medicago ruthenica MN901635", "Medicago edgeworthii MN901946", "Medicago arabica OL351132", "Medicago turbinata OL351133", "Medicago rotata OL351134", "Medicago murex OL351135", "Medicago rugosa OL351137", "Medicago granadensis OL351140", "Medicago coronata OL351142", "Medicago constricta OL351143", "Medicago littoralis OL351145", "Medicago scutellata OL351148", "Medicago italica OL351150", "Medicago lesinsii OL351153", "Medicago heyniana OL351154", "Medicago praecox OL351156", "Medicago soleirolii OL351157", "Medicago rigiduloides OL351159", "Medicago doliata OL351161", "Medicago ciliaris OL351162", "Medicago sativa subsp. caerulea OM009291", "Medicago lupulina OM681370", "Medicago polymorpha OM763664", "Medicago sativa OP514753", "Medicago sativa subsp. falcata PV890881", "Medicago sativa subsp. falcata PX878805")
data_files <- c("Table3_KF241982_Neutrality.csv", "Table3_KJ850240_Neutrality.csv", "Table3_KJ850241_Neutrality.csv", "Table3_MN901634_Neutrality.csv", "Table3_MN901635_Neutrality.csv", "Table3_MN901946_Neutrality.csv", "Table3_OL351132_Neutrality.csv", "Table3_OL351133_Neutrality.csv", "Table3_OL351134_Neutrality.csv", "Table3_OL351135_Neutrality.csv", "Table3_OL351137_Neutrality.csv", "Table3_OL351140_Neutrality.csv", "Table3_OL351142_Neutrality.csv", "Table3_OL351143_Neutrality.csv", "Table3_OL351145_Neutrality.csv", "Table3_OL351148_Neutrality.csv", "Table3_OL351150_Neutrality.csv", "Table3_OL351153_Neutrality.csv", "Table3_OL351154_Neutrality.csv", "Table3_OL351156_Neutrality.csv", "Table3_OL351157_Neutrality.csv", "Table3_OL351159_Neutrality.csv", "Table3_OL351161_Neutrality.csv", "Table3_OL351162_Neutrality.csv", "Table3_OM009291_Neutrality.csv", "Table3_OM681370_Neutrality.csv", "Table3_OM763664_Neutrality.csv", "Table3_OP514753_Neutrality.csv", "Table3_PV890881_Neutrality.csv", "Table3_PX878805_Neutrality.csv")
combined_data <- read_indexed_files(data_files, species_names)
if ("Neutrality_Main_Plot_Included" %in% names(combined_data)) {
  .keep <- tolower(as.character(combined_data[["Neutrality_Main_Plot_Included"]])) %in% c("true", "1", "yes", "pass", "included")
  combined_data <- combined_data[.keep, , drop = FALSE]
}

required_cols <- c("GC3", "GC12")
missing_cols <- setdiff(required_cols, names(combined_data))
if (length(missing_cols) > 0) stop(paste("Fig3 input missing columns:", paste(missing_cols, collapse = ", ")))

combined_data <- add_gene_metadata(combined_data) %>%
  mutate(
    GC3 = to_num(GC3),
    GC12 = to_num(GC12),
    ENC = if ("ENC" %in% names(.)) to_num(ENC) else NA_real_,
    Total_Codons = if ("Total_Codons" %in% names(.)) to_num(Total_Codons) else if ("seq" %in% names(.)) floor(nchar(as.character(seq)) / 3) else NA_real_,
    Species = factor(Species, levels = species_names),
    Genus = extract_genus(as.character(Species))
  ) %>%
  filter(is.finite(GC3), is.finite(GC12), GC3 >= 0, GC3 <= 1, GC12 >= 0, GC12 <= 1)

if (nrow(combined_data) == 0) stop("No valid numeric GC3/GC12 data for Fig3.")
combined_data$Point_Size <- ifelse(is.finite(combined_data$Total_Codons) & combined_data$Total_Codons > 0, pmax(1, combined_data$Total_Codons), 1)
label_data <- select_gene_label_data(combined_data, "GC3", "GC12", per_species_limit = 10L, global_all_limit = 70L)

fit_species_model <- function(df) {
  df <- df[is.finite(df$GC3) & is.finite(df$GC12), , drop = FALSE]
  if (nrow(df) < 2 || sd(df$GC3, na.rm = TRUE) == 0) {
    return(data.frame(Intercept = NA_real_, Slope = NA_real_, R2 = NA_real_, Equation = "n < 2", R2_Label = "R² = NA"))
  }
  fit <- lm(GC12 ~ GC3, data = df)
  intercept <- unname(coef(fit)[1]); slope <- unname(coef(fit)[2]); r2 <- summary(fit)$r.squared
  data.frame(
    Intercept = intercept, Slope = slope, R2 = r2,
    Equation = paste0("y = ", sprintf("%.4f", slope), "x ", ifelse(intercept >= 0, "+ ", "- "), sprintf("%.4f", abs(intercept))),
    R2_Label = paste0("R² = ", sprintf("%.4f", r2)), stringsAsFactors = FALSE
  )
}

regression_data <- combined_data %>% group_by(Species) %>% group_modify(~fit_species_model(.x)) %>% ungroup()
regression_data$Label <- paste(regression_data$Equation, regression_data$R2_Label, sep = "\n")
write.csv(regression_data, "Fig3_Neutrality_regression_summary.csv", row.names = FALSE)
write_optional_xlsx(regression_data, "Fig3_Neutrality_regression_summary.xlsx")

species_levels <- levels(combined_data$Species)
dims_species <- figure_dims(length(species_levels), base_w = 4.2, base_h = 3.6, max_w = 22, max_h = 30)
facet_labeller <- make_species_labeller(species_levels)

gg_base <- ggplot(combined_data, aes(x = GC3, y = GC12)) +
  geom_abline(slope = 1, intercept = 0, colour = "#D55E00", linetype = "dashed", linewidth = 0.55) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, colour = "#0173B2", linewidth = 0.55, na.rm = TRUE) +
  geom_point(aes(colour = Gene_Function, size = Point_Size), alpha = 0.78, na.rm = TRUE) +
  scale_colour_manual(values = gene_function_colors, drop = FALSE) +
  scale_size_continuous(range = c(1.5, 2.5), transform = "log10", breaks = function(lims) {{ candidates <- c(25, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 30000, 40000); lo <- max(1, min(lims, na.rm = TRUE)); hi <- max(lims, na.rm = TRUE); br <- candidates[candidates >= lo & candidates <= hi]; if (length(br) < 3) br <- pretty(c(lo, hi), n = 4); if (length(br) > 6) br <- br[unique(round(seq(1, length(br), length.out = 6)))]; unique(pmax(1, round(br))) }}, labels = scales::label_number(accuracy = 1, big.mark = ",")) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1), expand = TRUE) +
  scale_x_continuous(labels = function(x) ifelse(abs(x) < 1e-5, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(abs(x) < 1e-5, "0", sprintf("%.2f", x))) +
  labs(x = "GC3", y = "GC12", colour = "Gene function", size = "Codon number") +
  journal_theme(base_size = 11)

p_species <- gg_base +
  facet_wrap(~Species, ncol = as.integer(dims_species["ncol"]), labeller = facet_labeller) +
  geom_text(data = regression_data, aes(x = 0.03, y = 0.97, label = Label), inherit.aes = FALSE,
            hjust = 0, vjust = 1, size = 3.3, family = bold_family, fontface = bold_face, colour = "#B2182B") +
  theme(legend.position = "right")
if (has_ggrepel && nrow(label_data) > 0) {
  p_species <- p_species + ggrepel::geom_text_repel(
    data = label_data,
    aes(label = Gene_Label, colour = Gene_Function),
    family = italic_family, fontface = italic_face,
    size = gene_label_size(nrow(label_data)), max.overlaps = Inf,
    box.padding = 0.26, point.padding = 0.12, min.segment.length = 0,
    segment.size = 0.20, show.legend = FALSE, seed = 123
  )
}

genus_levels <- sort(unique(combined_data$Genus))
dims_genus <- figure_dims(length(genus_levels), base_w = 4.2, base_h = 3.6, max_w = 22, max_h = 26)
p_genus <- gg_base +
  facet_wrap(~Genus, ncol = as.integer(dims_genus["ncol"]), labeller = make_taxon_labeller(genus_levels)) +
  theme(legend.position = "right")
if (has_ggrepel && nrow(label_data) > 0) {
  p_genus <- p_genus + ggrepel::geom_text_repel(
    data = label_data,
    aes(label = Gene_Label, colour = Gene_Function),
    family = italic_family, fontface = italic_face,
    size = gene_label_size(nrow(label_data)), max.overlaps = Inf,
    box.padding = 0.26, point.padding = 0.12, min.segment.length = 0,
    segment.size = 0.20, show.legend = FALSE, seed = 123
  )
}


# ========================= current workflow extra species-colour PDF =========================
# current workflow: Style synchronized with Fig2/Fig3/Fig4 v7 R scripts and current workflow palette.
# The extra by_species__species_palette plot uses species-level colours, compact
# dimensions, PDF-only saving, Times-style axes, and italic Latin species names in
# the Species legend using the same italic_family/italic_face as facet strips.
make_species_palette_current workflow <- function(levels_vec) {
  lv <- sort(unique(as.character(levels_vec)))
  base_cols <- c("#0173B2", "#DE8F05", "#029E73", "#D55E00", "#CC78BC", "#CA9161", "#FBAFE4", "#949494", "#ECE133", "#56B4E9", "#E69F00", "#009E73", "#F0E442", "#0072B2", "#CC79A7", "#000000", "#3B4992", "#EE0000", "#008B45", "#631879", "#008280", "#BB0021", "#5F559B", "#A20056", "#808180", "#1B1919", "#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD", "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF", "#00468B", "#ED0000", "#42B540", "#0099B4", "#925E9F", "#FDAF91", "#AD002A", "#ADB6B6", "#2E86AB", "#A23B72", "#F18F01", "#C73E1D", "#4895EF", "#4CC9F0", "#16537E", "#6A994E", "#A7C957", "#BC4749", "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FECA57", "#FF9FF3", "#54A0FF", "#5F27CD", "#00D2D3", "#FF9F43", "#EE5A24", "#10AC84", "#0652DD", "#9C88FF", "#FFC048", "#ED4C67", "#833471")
  cols <- rep(base_cols, length.out = length(lv))
  names(cols) <- lv
  cols
}

species_latin_only_current workflow <- function(x) {
  vapply(as.character(x), function(z) strip_accession(species_display_name(z)), character(1), USE.NAMES = FALSE)
}

species_palette_current workflow <- make_species_palette_current workflow(species_levels)
species_legend_cols_current workflow <- if (length(species_levels) > 50) 2L else 1L
species_legend_labels_current workflow <- species_latin_only_current workflow(species_levels)
species_legend_text_italic_current workflow <- element_text(
  family = italic_family,
  face = italic_face,
  colour = "black",
  size = 11 * 0.999
)
codon_legend_text_plain_current workflow <- element_text(
  family = base_family,
  face = "plain",
  colour = "black",
  size = 11 * 0.999
)
species_legend_guide_current workflow <- guides(
  colour = guide_legend(
    ncol = species_legend_cols_current workflow,
    byrow = FALSE,
    override.aes = list(alpha = 1, size = 2.8)
  ),
  size = guide_legend(
    ncol = 1,
    theme = theme(legend.text = codon_legend_text_plain_current workflow)
  )
)
species_italic_legend_theme_current workflow <- journal_theme(base_size = 11) %+replace% theme(
  legend.text = species_legend_text_italic_current workflow
)
# ======================= end current workflow extra species-colour PDF =======================

gg_base_species__palette <- ggplot(combined_data, aes(x = GC3, y = GC12)) +
  geom_abline(slope = 1, intercept = 0, colour = "#D55E00", linetype = "dashed", linewidth = 0.55) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, colour = "#0173B2", linewidth = 0.55, na.rm = TRUE) +
  geom_point(aes(colour = Species, size = Point_Size), alpha = 0.50, na.rm = TRUE) +
  scale_colour_manual(values = species_palette_current workflow, breaks = species_levels, labels = species_legend_labels_current workflow, drop = FALSE) +
  scale_size_continuous(range = c(1.5, 2.5), transform = "log10", breaks = function(lims) {{ candidates <- c(25, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 30000, 40000); lo <- max(1, min(lims, na.rm = TRUE)); hi <- max(lims, na.rm = TRUE); br <- candidates[candidates >= lo & candidates <= hi]; if (length(br) < 3) br <- pretty(c(lo, hi), n = 4); if (length(br) > 6) br <- br[unique(round(seq(1, length(br), length.out = 6)))]; unique(pmax(1, round(br))) }}, labels = scales::label_number(accuracy = 1, big.mark = ",")) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1), expand = TRUE) +
  scale_x_continuous(labels = function(x) ifelse(abs(x) < 1e-5, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(abs(x) < 1e-5, "0", sprintf("%.2f", x))) +
  labs(x = "GC3", y = "GC12", colour = "Species", size = "Codon number") +
  species_italic_legend_theme_current workflow

p_species__palette <- gg_base_species__palette +
  facet_wrap(~Species, ncol = as.integer(dims_species["ncol"]), labeller = facet_labeller) +
  geom_text(data = regression_data, aes(x = 0.03, y = 0.97, label = Label), inherit.aes = FALSE,
            hjust = 0, vjust = 1, size = 3.3, family = bold_family, fontface = bold_face, colour = "#B2182B") +
  theme(legend.position = "right") +
  species_legend_guide_current workflow

if (has_ggrepel && nrow(label_data) > 0) {
  p_species__palette <- p_species__palette + ggrepel::geom_text_repel(
    data = label_data,
    aes(label = Gene_Label, colour = Species),
    family = italic_family, fontface = italic_face,
    size = gene_label_size(nrow(label_data)), max.overlaps = Inf,
    box.padding = 0.26, point.padding = 0.12, min.segment.length = 0,
    segment.size = 0.20, show.legend = FALSE, seed = 123
  )
}

ggsave("Fig3_Neutrality_by_species_species_palette.pdf", p_species__palette,
       width = max(7.2, dims_species["width"]), height = max(5.4, 0.82*dims_species["height"]), device = pdf_device)
message("Fig3 current workflow extra PDF generated: Fig3_Neutrality_by_species_species_palette.pdf")


ggsave("Fig3_Neutrality_by_species.pdf", p_species, width = max(7.2, dims_species["width"]), height = max(5.4, 0.82*dims_species["height"]), device = pdf_device)
# current workflow: obsolete duplicate Fig3 genus save suppressed; the adaptive canonical save below is retained.
message("Fig3 Neutrality completed: ", length(species_levels), " species; ", nrow(combined_data), " genes.")


# ======================= current workflow five species palettes =======================
generate_extended_colors_current workflow <- function(base_cols, n) {
  base_cols <- unique(as.character(base_cols)); n <- max(1L, as.integer(n))
  if (n <= length(base_cols)) return(base_cols[seq_len(n)])
  grDevices::colorRampPalette(base_cols)(n)
}
color_schemes_current workflow <- list(
  nature_standard = c("#0173B2","#DE8F05","#029E73","#D55E00","#CC78BC","#CA9161","#FBAFE4","#949494","#ECE133","#56B4E9","#E69F00","#009E73","#F0E442","#0072B2","#CC79A7","#000000","#2E86AB","#A23B72","#F18F01","#C73E1D","#4895EF","#4CC9F0","#16537E","#6A994E","#A7C957","#F2E8CF","#BC4749","#D4A574","#8B5A3C","#FF6B6B","#4ECDC4","#45B7D1","#96CEB4","#FECA57","#FF9FF3","#DDA15E","#BC6C25","#7209B7","#3A0CA3","#4361EE","#4CC9F0","#F72585","#B5179E","#7209B7","#560BAD","#480CA8","#3A0CA3","#3F37C9"),
  science_aaas = c("#3B4992","#EE0000","#008B45","#631879","#008280","#BB0021","#5F559B","#A20056","#808180","#1B1919","#F39800","#007BC7","#8A4182","#006838","#A51890","#CF4A2C","#009CA6","#B5007F","#E6194B","#3CB44B","#FFE119","#4363D8","#F58231","#911EB4","#46F0F0","#F032E6","#BCF60C","#FABEBE","#008080","#E6BEFF","#9A6324","#FFFAC8","#800000","#AAFFC3","#808000","#FFD8B1","#000075","#808080","#FFFFFF","#000000","#AA6E28","#FFFAC8","#800000","#AAFFC3","#808000","#FFD8B1","#000075","#808080"),
  cell_professional = c("#1F77B4","#FF7F0E","#2CA02C","#D62728","#9467BD","#8C564B","#E377C2","#7F7F7F","#BCBD22","#17BECF","#AEC7E8","#FFBB78","#98DF8A","#FF9896","#C5B0D5","#C49C94","#F7B6D3","#C7C7C7","#DBDB8D","#9EDAE5","#637939","#8C6239","#843C0C","#D68910","#A569BD","#5DADE2","#48C9B0","#F8C471","#EC7063","#85929E","#2C3E50","#E74C3C","#3498DB","#2ECC71","#F39C12","#9B59B6","#1ABC9C","#34495E","#16A085","#27AE60","#2980B9","#8E44AD","#2C3E50","#F39C12","#D35400","#C0392B","#BDC3C7","#7F8C8D"),
  lancet_medical = c("#00468B","#ED0000","#42B540","#0099B4","#925E9F","#FDAF91","#AD002A","#ADB6B6","#1B1919","#FF9999","#E07B91","#8491B4","#91D1C2","#DC8665","#39568C","#4F2C1D","#15559A","#AD0000","#007EB1","#FFB90F","#8B8B8B","#00A0AC","#CC79A7","#B15928","#A6D8F0","#F79CD4","#006635","#FFCE44","#8B0000","#2E8B57","#FF6A6A","#4169E1","#FF8C00","#9370DB","#00CED1","#DC143C","#00FA9A","#1E90FF","#FF1493","#FFD700","#8A2BE2","#00FF7F","#FF4500","#DA70D6","#32CD32","#FF69B4","#4B0082","#00CED1"),
  journal_best_practice = c("#0173B2","#DE8F05","#029E73","#CC78BC","#3B4992","#EE0000","#008B45","#631879","#1F77B4","#FF7F0E","#2CA02C","#D62728","#00468B","#ED0000","#42B540","#0099B4","#2E86AB","#A23B72","#F18F01","#C73E1D","#4B5D67","#7209B7","#F72585","#4895EF","#4CC9F0","#7CB9E8","#16537E","#6A994E","#A7C957","#F2E8CF","#BC4749","#D4A574","#8B5A3C","#FF6B6B","#4ECDC4","#45B7D1","#96CEB4","#FECA57","#FF9FF3","#DDA15E","#BC6C25","#7209B7","#3A0CA3","#4361EE","#4CC9F0","#F72585","#B5179E","#7209B7")
)
remove_colour_scale_current workflow <- function(p) {
  if (is.null(p$scales) || length(p$scales$scales) == 0) return(p)
  keep <- !vapply(p$scales$scales, function(s) any(c("colour", "color") %in% s$aesthetics), logical(1))
  p$scales$scales <- p$scales$scales[keep]; p
}
# ===================== end current workflow five species palettes =====================

for (scheme_name_current workflow in names(color_schemes_current workflow)) {
  palette_current workflow <- stats::setNames(generate_extended_colors_current workflow(color_schemes_current workflow[[scheme_name_current workflow]], length(species_levels)), species_levels)
  plot_current workflow <- remove_colour_scale_current workflow(p_species__palette) +
    ggplot2::scale_colour_manual(values = palette_current workflow, breaks = species_levels, labels = species_legend_labels_current workflow, drop = FALSE)
  ggplot2::ggsave(
    paste0("Fig3_Neutrality_by_species_", scheme_name_current workflow, ".pdf"), plot_current workflow,
    width = max(7.2, dims_species["width"]), height = max(5.4, 0.82*dims_species["height"]), device = pdf_device
  )
}
message("Fig3 current workflow five species-palette PDFs generated.")

# ========================= current workflow genus-plot legend harmonisation =========================
# The original plot theme may use ggtext::element_markdown() for legend.text.
# Adding a plain element_text() theme on top of that raises ggplot2's
# "Only elements of the same class can be merged" error. current workflow therefore:
#   1) updates only non-text legend properties through theme();
#   2) assigns a class-compatible legend.text element directly to the plot theme;
#   3) uses the same element class in the guide-specific size legend theme.
species_legend_cols <- if (length(species_levels) <= 48) 1L else ceiling(length(species_levels) / 48)
species_legend_rows <- ceiling(length(species_levels) / species_legend_cols)
genus_width <- max(7.0, 0.90 * dims_genus["width"], min(40, 7.0 + 2.2 * max(0, species_legend_cols - 1)))
genus_height <- max(5.2, 0.82 * dims_genus["height"], min(60, 5.0 + 0.23 * species_legend_rows))
use_markdown_legend <- exists("has_ggtext") && isTRUE(has_ggtext) && requireNamespace("ggtext", quietly = TRUE)
species_legend_text <- if (use_markdown_legend) {
  ggtext::element_markdown(family = italic_family, colour = "black")
} else {
  ggplot2::element_text(family = italic_family, face = italic_face, colour = "black")
}
plain_legend_text <- if (use_markdown_legend) {
  ggtext::element_markdown(family = base_family, colour = "black")
} else {
  ggplot2::element_text(family = base_family, face = "plain", colour = "black")
}
p_genus <- p_genus +
  ggplot2::theme(
    legend.position = "right",
    legend.box = "vertical",
    legend.direction = "vertical"
  )
# Direct assignment avoids theme-element class merging.
p_genus$theme[["legend.text"]] <- species_legend_text
p_genus <- p_genus +
  ggplot2::guides(
    colour = ggplot2::guide_legend(
      ncol = species_legend_cols,
      byrow = FALSE,
      override.aes = list(alpha = 1, size = 2.8)
    ),
    size = ggplot2::guide_legend(
      ncol = 1,
      byrow = FALSE,
      theme = ggplot2::theme(legend.text = plain_legend_text)
    )
  )
# ======================= end current workflow genus-plot legend harmonisation =======================

ggsave("Fig3_Neutrality_by_genus.pdf", p_genus, width = genus_width, height = genus_height, device = pdf_device)
writeLines(c("Workflow release: current", "Species legend: one column through 48 taxa; minimum adaptive columns above 48", "Codon-number legend: one column", "Latin species labels: timesitalic"), "Fig3_By_Genus_Legend_Contract.txt")
