@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Avião Comprado x Licenças'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_mat_rme_control
  as select from ztdp_matrmectdma

  association to parent ZR_MAT_RME as _MatRme on  _MatRme.Matnr = $projection.Matnr
                                              and _MatRme.Omrme = $projection.Omrme


{

  key codemb      as Matnr,
  key omrme       as Omrme,

      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_NXL_LICENSE_EMB_VH', element: 'ExpSecurity' },
                                            additionalBinding: [ { element: 'ExportLicense', localElement: 'ExportLicense', usage: #RESULT } ],
                                            useForValidation: true
                                          } ]
  key expsecrty   as ExpSecurity,

      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_NXL_LICENSE_EMB_VH', element: 'ExportLicense' },
                                            additionalBinding: [ { element: 'ExpSecurity', localElement: 'ExpSecurity', usage: #RESULT } ],
                                            useForValidation: true
                                          } ]
  key exportlic   as ExportLicense,

      @Semantics.user.createdBy: true
      uname       as Uname,
      aedat       as Aedat,
      uptim       as Uptim,

      status      as Status,

      //--Definir status
      case status
        when 'A' then 'ADD'
        when 'U' then 'UPD'
        when 'D' then 'DEL'
        else ' '
        end       as StatusText,

      // Obter as licenças para Material Controlado - com TAA (Oracle)
      'ZDPNMM177' as LicenseNumber,

      /* Associations */
      _MatRme

}
