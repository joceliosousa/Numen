@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help - Grupo Certificado'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_GRUPO_CERT_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZGRUPO' )
{
      @ObjectModel.text.element: [ 'GrupoCertificadoDescription' ]
  key cast( value_low as zgrupo ) as GrupoCertificado,

      text                        as GrupoCertificadoDescription
}
where
  language = $session.system_language
