@EndUserText.label : 'Material Avião Comprado x Licenças'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmectdma {

  key mandt     : abap.clnt not null;
  key codemb    : matnr not null;
  key omrme     : zomrme not null;
  key expsecrty : abap.char(4) not null;
  key exportlic : abap.char(10) not null;
  uname         : abap.char(12);
  aedat         : abap.dats;
  uptim         : abap.tims;
  status        : abap.char(1);

}
