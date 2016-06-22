#'Efetua o login no sistema da CVM
#'
#'@param login seu login
#'@param senha sua senha
#'@return the SOAP header enviada pelo sistema para ser utilizada em outras funções
#'@export cvm_login

cvm_login <- function(login, senha){
  headerfields = c(
    Accept = "text/xml",
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    SOAPAction = "http://www.cvm.gov.br/webservices/Login"
  )

  body = paste0("<?xml version='1.0' encoding='utf-8'?>
  <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
  <soap:Header>
  <sessaoIdHeader xmlns='http://www.cvm.gov.br/webservices/'>
  <Guid>8200ac01-bfb5-46d6-a625-38108141fb33</Guid>
  <IdSessao>135128883</IdSessao>
  </sessaoIdHeader>
  </soap:Header>
  <soap:Body>
  <Login xmlns='http://www.cvm.gov.br/webservices/'>
  <iNrSist>",
  login,
  "</iNrSist>
  <strSenha>",
  senha,
  "</strSenha>
  </Login>
  </soap:Body>
  </soap:Envelope>")

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


soapheader <-  XML::getNodeSet(xml, "/soap:Envelope/soap:Header")
soapheader_ch <- methods::as(soapheader[[1]], "character")
soapheader_ch
}
