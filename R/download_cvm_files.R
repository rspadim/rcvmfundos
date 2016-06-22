#'Lista de arquivos atualmente disponibilizados no sistema
#'
#'@param soapheader SOAP Header obtido com a função cvm_login
#'@param inicdeliverydate data inicial de entrega dos documentos
#'@return data.frame com datas dos arquivos disponíveis
#'@export cvm_listacomptc

cvm_listacomptc <- function(soapheader, inicdeliverydate = Sys.Date()-3){
  headerfields = c(
    Accept = "text/xml",
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    SOAPAction = "http://www.cvm.gov.br/webservices/retornaListaComptcDocs"
  )

  body = paste0(
    '<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">',
    soapheader,
    '<soap:Body>
    <retornaListaComptcDocs xmlns="http://www.cvm.gov.br/webservices/">
    <iCdTpDoc>209</iCdTpDoc>
    <strDtIniEntregDoc>',
    inicdeliverydate,
    '</strDtIniEntregDoc>
    </retornaListaComptcDocs>
    </soap:Body>
    </soap:Envelope>'
  )

  reader = RCurl::basicTextGatherer()

  RCurl::curlPerform(
    url = "http://sistemas.cvm.gov.br/webservices/Sistemas/SCW/CDocs/WsDownloadInfs.asmx",
    httpheader = headerfields,
    postfields = body,
    writefunction = reader$update
  )

  xml <- reader$value()
  xml <- XML::xmlInternalTreeParse(xml)
  xml

  lista <- XML::xmlToDataFrame(XML::getNodeSet(xml, "/soap:Envelope/soap:Body")[[1]][[1]][[1]])
  lista
}


#'Download do arquivo XML de dados diários na data especificada
#'
#'@param soapheader SOAP Header obtido com a função cvm_login
#'@param date data do arquivo
#'@return arquivo XML no diretório atual
#'@export cvm_arqcomptc

cvm_arqcomptc <- function(soapheader,
                          date){
  headerfields = c(
    Accept = "text/xml",
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    SOAPAction = "http://www.cvm.gov.br/webservices/solicAutorizDownloadArqComptc"
  )

  body = paste0('<?xml version="1.0" encoding="utf-8"?>
                <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">',
                soapheader,
                '<soap:Body>
                <solicAutorizDownloadArqComptc xmlns="http://www.cvm.gov.br/webservices/">
                <iCdTpDoc>209</iCdTpDoc>
                <strDtComptcDoc>',
                date,
                '</strDtComptcDoc>
                <strMotivoAutorizDownload>download-text</strMotivoAutorizDownload>
                </solicAutorizDownloadArqComptc>
                </soap:Body>
                </soap:Envelope>')

  reader = RCurl::basicTextGatherer()

  RCurl::curlPerform(
    url = "http://sistemas.cvm.gov.br/webservices/Sistemas/SCW/CDocs/WsDownloadInfs.asmx",
    httpheader = headerfields,
    postfields = body,
    writefunction = reader$update
  )

  xml <- reader$value()
  xml
  xml <- XML::xmlInternalTreeParse(xml)

  url <- XML::xmlSApply(XML::xmlRoot(xml)[[2]], XML::xmlValue)

  download.file(url, "arquivocvm.zip", mode = "wb")

  f <- unzip("arquivocvm.zip")
  file.remove("arquivocvm.zip")
  f
  }

#'Download do arquivo XML com dados de cadastro dos fundos na data especificada
#'
#'@param soapheader SOAP Header obtido com a função cvm_login
#'@param date data do arquivo
#'@return arquivo XML no diretório atual
#'@export cvm_cadastro

cvm_cadastro <- function(soapheader,
                         date){
  headerfields = c(
    Accept = "text/xml",
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    SOAPAction = "http://www.cvm.gov.br/webservices/solicAutorizDownloadCadastro"
  )

  body = paste0(
    '<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">',
    soapheader,
    '<soap:Body>
    <solicAutorizDownloadCadastro xmlns="http://www.cvm.gov.br/webservices/">
    <strDtRefer>',
    date,
    '</strDtRefer>
    <strMotivoAutorizDownload>string</strMotivoAutorizDownload>
    </solicAutorizDownloadCadastro>
    </soap:Body>
    </soap:Envelope>'
  )

  reader = RCurl::basicTextGatherer()

  RCurl::curlPerform(
    url = "http://sistemas.cvm.gov.br/webservices/Sistemas/SCW/CDocs/WsDownloadInfs.asmx",
    httpheader = headerfields,
    postfields = body,
    writefunction = reader$update
  )

  xml <- reader$value()
  xml <- XML::xmlInternalTreeParse(xml)
  xml

  url <- XML::xmlSApply(XML::xmlRoot(xml)[[2]], XML::xmlValue)

  download.file(url, "arquivocvm.zip", mode = "wb")

  f <- unzip("arquivocvm.zip")
  file.remove("arquivocvm.zip")
  f
  }

#'Download de arquivo zip com arquivos XML de vários dias
#'
#'@param soapheader SOAP Header obtido com a função cvm_login
#'@return arquivo zip
#'@export cvm_arqanual

cvm_arqanual <- function(soapheader){

  headerfields = c(
    Accept = "text/xml",
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    SOAPAction = "http://www.cvm.gov.br/webservices/solicAutorizDownloadArqAnual"
  )

  body = paste0(
    '<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">',
    soapheader,
    '<soap:Body>
    <solicAutorizDownloadArqAnual xmlns="http://www.cvm.gov.br/webservices/">
    <iCdTpDoc>',
    "209",
    '</iCdTpDoc>
    <strMotivoAutorizDownload>download-text</strMotivoAutorizDownload>
    </solicAutorizDownloadArqAnual>
    </soap:Body>
    </soap:Envelope>'
  )

  reader = RCurl::basicTextGatherer()

  RCurl::curlPerform(
    url = "http://sistemas.cvm.gov.br/webservices/Sistemas/SCW/CDocs/WsDownloadInfs.asmx",
    httpheader = headerfields,
    postfields = body,
    writefunction = reader$update
  )

  xml <- reader$value()
  xml <- XML::xmlInternalTreeParse(xml)
  xml

  url <- XML::xmlSApply(XML::xmlRoot(xml)[[2]], XML::xmlValue)

  download.file(url, "arquivocvm.zip", mode = "wb")

}
