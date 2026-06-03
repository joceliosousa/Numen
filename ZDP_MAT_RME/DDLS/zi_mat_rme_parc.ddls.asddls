@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material RME x Parceiro'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MAT_RME_PARC
  as select from ztdp_matrmeforma

  association        to parent ZR_MAT_RME as _MatRme   on  _MatRme.Matnr = $projection.Matnr
                                                       and _MatRme.Omrme = $projection.Omrme
  association [1..1] to I_Supplier        as _Supplier on  $projection.Lifnr = _Supplier.Supplier
  association        to I_Country         as _Country  on  $projection.SupplierCountry = _Country.Country

{

  key matnr                                      as Matnr,
  key omrme                                      as Omrme,

      @Consumption.valueHelpDefinition: [ { entity : { name: 'I_Supplier_VH', element: 'Supplier' },
                                            useForValidation: true
                                          } ]
  key lifnr                                      as Lifnr,

  key werks                                      as Werks,

      indempa                                    as Indempa,
      emnfr                                      as Emnfr,
      sperrfkt                                   as Sperrfkt,
      sperrfkt_orig                              as SperrfktOrig,
      msds                                       as Msds,
      num_msds_orig                              as NumMsdsOrig,
      msdsdoc                                    as Msdsdoc,
      ind_anex_msds                              as IndAnexMsds,

      status                                     as Status,

      case status
        when 'A' then 'ADD'
        when 'U' then 'UPD'
        when 'D' then 'DEL'
        else ' '
        end                                      as StatusText,

      cast( 'EMBRAER' as abap.char( 30 ) )       as SupplierCompanyName,
      cast( '+55' as abap.char( 16 ) )           as SupplierBrazilPhoneCode,
      _Supplier.AddressID                        as SupplierAddressID,
      _Supplier.Country                          as SupplierCountry,

      cast('X' as abap_boolean preserving type ) as EditHidden,

      @Semantics.user.createdBy: true
      userincl                                   as Userincl,
      dataincl                                   as Dataincl,
      horaincl                                   as Horaincl,

      @Semantics.user.lastChangedBy: true
      useralt                                    as Useralt,
      dataalt                                    as Dataalt,
      horaalt                                    as Horaalt,

      /* Associations */
      _MatRme,
      _Supplier,
      _Country

}
where
  indempa = 'P'
