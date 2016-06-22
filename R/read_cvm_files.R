#'Leitura do arquivo XML da CVM
#'
#'@param file arquivo XML do servidor da CVM
#'@return data.frame com os dados do arquivo
#'@export read_cvmxmlfile

read_cvmxmlfile <- function(file){
    x <- XML::xmlInternalTreeParse(file)
    informes <- XML::getNodeSet(x, "/ROOT/INFORMES/INFORME_DIARIO")
    informes <- XML::xmlToDataFrame(informes)
    cabecalho <- XML::getNodeSet(x, "/ROOT/CABECALHO")
    cabecalho <- XML::xmlToDataFrame(cabecalho)
    informes <- dplyr::tbl_df(informes)
    informes <- dplyr::mutate(informes, DT_REFER = as.character(cabecalho[1,"DT_REFER"]))
    informes <- dplyr::mutate(informes, DT_GERAC = as.character(cabecalho[1,"DT_GERAC"]))
    informes <- dplyr::mutate(informes, TP_REFER = as.character(cabecalho[1,"TP_REFER"]))
    informes <- dplyr::mutate(informes, id = paste0(CNPJ_FDO, DT_COMPTC))
    informes <- apply(informes, 2, function(x){sub(",", ".", x)})
    informes <- data.frame(informes)
    informes
}

#'Leitura do arquivo XML de dados cadstrais da CVM
#'
#'@param file arquivo XML do servidor da CVM
#'@return data.frame com os dados do arquivo
#'@export read_cvmxmlcad


read_cvmxmlcad <- function(file){
  x <- file
  x <- XML::xmlInternalTreeParse(x)
  informes <- XML::getNodeSet(x, "/ROOT/PARTICIPANTES/CADASTRO")
  informes <- XML::xmlToDataFrame(informes)
  cabecalho <- XML::getNodeSet(x, "/ROOT/CABECALHO")
  cabecalho <- XML::xmlToDataFrame(cabecalho)
  informes <- dplyr::tbl_df(informes)
  informes <- dplyr::mutate(informes, DT_REFER = as.character(cabecalho[1,"DT_REFER"]))
  informes <- dplyr::mutate(informes, DT_GERAC = as.character(cabecalho[1,"DT_GERAC"]))
  informes <- dplyr::mutate(informes, TP_REFER = as.character(cabecalho[1,"TP_REFER"]))
  try(informes <- dplyr::mutate(informes, id = paste0(CNPJ, DT_REFER)))
  informes <- data.frame(informes)
}
