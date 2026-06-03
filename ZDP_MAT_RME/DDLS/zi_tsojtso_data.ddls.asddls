@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados da Certificação - TSO/JTSO'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZI_TSOJTSO_DATA
  as select from ztdp_tsojtsodata
{
  key matnr    as Matnr,
  key certtype as CertType,
  key certnumb as CertNumb,
      grupo    as Grupo,
      dal      as Dal,
      indappro as IndAppro,
      userincl as UserIncl,
      dataincl as DataIncl,
      horaincl as HoraIncl,
      useralt  as UserAlt,
      dataalt  as DataAlt,
      horaalt  as HoraAlt
}
