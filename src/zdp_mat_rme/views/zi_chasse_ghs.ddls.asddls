@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Classe GHS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CHASSE_GHS
  as select from ztdp_classe_ghs
{
  key cod_ghs                         as CodGHS,
      cast(  case cast( $session.system_language as spras)
           when 'P' then dsc_per_pt
           when 'E' then dsc_per_en
           else dsc_per_en
      end      as    abap.char(100) ) as Descricao,
      dsc_per_pt                      as DscPerPt,
      dsc_per_en                      as DscPerEn,
      cast(  case cast( $session.system_language as spras)
           when 'P' then pal_adv_pt
           when 'E' then pal_adv_en
           else pal_adv_en
      end      as    abap.char(100) ) as PalavraAdvertencia,
      pal_adv_pt                      as PalAdvPt,
      pal_adv_en                      as PalAdvEn,
      img_picto                       as ImgPicto
}
