@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help - TipoCertificado'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_CERTTYPE_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZCERTTYPE' )
{
      @ObjectModel.text.element: [ 'TipoCertificadoDescription' ]
  key cast( value_low as zcerttype ) as TipoCertificado,

      text                           as TipoCertificadoDescription
}
where
  language = $session.system_language
