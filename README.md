Esse pacote foi desenvolvido para efetuar o download e leitura dos arquivos de dados de fundos de investimento disponibilizados em formato XML pelo sistema da CVM (Comissão de Valores Mobiliários), a SEC (Securities and Exchange Comission) brasileira.

Para poder utilizar as funções, é necessário efetuar um cadastro no sistema da CVM e obter sua senha e login. Para conhecer os manuais do sistema acesse <http://cvmweb.cvm.gov.br/SWB/Sistemas/SWS/DownloadInfs/ManualDownloadInfs.aspx> e o cadastro pode ser efetuado em <http://cvmweb.cvm.gov.br/SWB/Sistemas/SAU/Usuario/CpfCad.aspx>.

As principais funções são cvm\_login, cvm\_arqcomptc, read\_cvmxmlfile. O código abaixo pode ser usado como exemplo de utilização trivial do pacote:

``` r
library(rcvmfundos)

arquivo <- cvm_arqcomptc(soapheader = cvm_login(login = "xxxx", senha = "xxxxx"), date = "yyyy-mm-dd")
#> Error in soapheader[[1]]: índice fora de limites
df <- read_cvmxmlfile(arquivo)
#> Error in XML::xmlInternalTreeParse(file, encoding = "UTF-8"): objeto 'arquivo' não encontrado
```
