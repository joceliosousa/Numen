@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material RME x Kit RME'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MAT_RME_KIT
  as select from ztdp_matrmekitma

  association        to parent ZR_MAT_RME as _MatRme  on  _MatRme.Matnr = $projection.Matnr
                                                      and _MatRme.Omrme = $projection.Omrme

  association [0..1] to I_Product         as _Product on  $projection.Matnrkit = _Product.ProductManufacturerNumber

{

  key matnr                                      as Matnr,
  key omrme                                      as Omrme,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MFRPN_VH', element: 'ProductManufacturerNumber' }, useForValidation: true }]
  key matnrkit                                   as Matnrkit,

      _Product.Product                           as CodigoEmbraer,
      //_ProductText.ProductDescription as DesignacaoIngles,

      qtde                                       as Qtde,
      qtde_orig                                  as QtdeOrig,

      status                                     as Status,

      case status
        when 'A' then 'ADD'
        when 'U' then 'UPD'
        when 'D' then 'DEL'
        else ' '
        end                                      as StatusText,

      @Semantics.user.createdBy: true
      userincl                                   as Userincl,
      dataincl                                   as Dataincl,
      horaincl                                   as Horaincl,

      @Semantics.user.lastChangedBy: true
      useralt                                    as Useralt,
      dataalt                                    as Dataalt,
      horaalt                                    as Horaalt,

      cast('X' as abap_boolean preserving type ) as EditHidden,

      /* Associations */
      _MatRme,
      _Product
      // _ProductText
      //      _Mfrpn

}
