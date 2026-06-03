@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help - Status do Material'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_STATUS_MAT_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMATSTATUSPURCHASED' )
{
      @ObjectModel.text.element: [ 'StatusMaterialDescription' ]
  key cast( value_low as zstatus_mat ) as StatusMaterial,

      text                             as StatusMaterialDescription
}
where
  language = $session.system_language
