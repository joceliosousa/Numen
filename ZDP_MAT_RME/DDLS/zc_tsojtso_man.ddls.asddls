@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_TSOJTSO_MAN'
define view entity ZC_TSOJTSO_MAN
  as projection on ZI_TSOJTSO_MAN
{
  key Matnr,
  key Omrme,
  key CertType,
  key CertNumber,
      Grupo,
      Dal,
      IndApprovacao,
      Status,
      UserIncl,
      DataIncl,
      HoraIncl,
      UserAlt,
      DataAlt,
      HoraAlt,

      _MatRme : redirected to parent ZC_MAT_RME
}
