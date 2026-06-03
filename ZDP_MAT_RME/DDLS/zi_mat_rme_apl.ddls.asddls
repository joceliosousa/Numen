@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material RME Aplicacao'
define view entity ZI_MAT_RME_APL
  as select from ztdp_matrmeaplma

  association to parent ZR_MAT_RME as _MatRme on  _MatRme.Matnr = $projection.Matnr
                                              and _MatRme.Omrme = $projection.Omrme

{
  key matnr         as Matnr,
  key omrme         as Omrme,

      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_PLTF_VH',
            element: 'COD_PROJ_AENV'
          },
          useForValidation: true
        }
      ]
  key cod_proj_aenv as CodProjAenv,

      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_MAT_RME_TPDOCUMENTO_VH', element: 'TipoDocumento' },
                                            useForValidation: true
                                          } ]
  key doctype       as Doctype,
  key docnro        as Docnro,
      codpltf_orig  as CodpltfOrig,

      @Semantics.user.createdBy: true
      userincl      as Userincl,

      dataincl      as Dataincl,
      horaincl      as Horaincl,

      @Semantics.user.createdBy: true
      useralt       as Useralt,
      dataalt       as Dataalt,
      horaalt       as Horaalt,

      status        as Status,

      //--Definir status
      case status
        when 'A' then 'ADD'
        when 'U' then 'UPD'
        when 'D' then 'DEL'
        else ' '
        end         as StatusText,

      /* Associations */
      _MatRme
}
