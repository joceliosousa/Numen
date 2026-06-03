@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados da Certificação - TSO/JTSO'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_TSOJTSO_MAN
  as select from ztdp_tsojtsomanu

  association to parent ZR_MAT_RME as _MatRme on  _MatRme.Matnr = $projection.Matnr
                                              and _MatRme.Omrme = $projection.Omrme
{
  key matnr    as Matnr,
  key omrme    as Omrme,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_CERTTYPE_VH', element: 'TipoCertificado' },
                                            useForValidation: true
                                        } ]
  key certtype as CertType,
  key certnumb as CertNumber,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_GRUPO_CERT_VH', element: 'GrupoCertificado' },
                                          useForValidation: true
                                      } ]
      grupo    as Grupo,
      dal      as Dal,
      indappro as IndApprovacao,
      status   as Status,
      userincl as UserIncl,
      //@Semantics.systemDateTime.createdAt: true
      dataincl as DataIncl,
      horaincl as HoraIncl,
      useralt  as UserAlt,
      //@Semantics.systemDateTime.lastChangedAt: true
      dataalt  as DataAlt,
      horaalt  as HoraAlt,

      _MatRme
}
