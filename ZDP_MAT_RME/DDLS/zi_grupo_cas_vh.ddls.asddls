@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help - GrupoCAS'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_GRUPO_CAS_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_GRUPO_CAS' )
{
      @ObjectModel.text.element: [ 'GrupoRestricaoDescription' ]
  key cast( value_low as zgrupo_cas ) as GrupoRestricao,

      text                            as GrupoRestricaoDescription
}
where
  language = $session.system_language
