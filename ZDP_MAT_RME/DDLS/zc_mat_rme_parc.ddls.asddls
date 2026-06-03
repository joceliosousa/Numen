@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_MAT_RME_PARC'
define view entity ZC_MAT_RME_PARC
  as projection on ZI_MAT_RME_PARC
{

  key Matnr,
  key Omrme,
  key Lifnr,
  key Werks,

      Indempa,
      Emnfr,
      Sperrfkt,
      SperrfktOrig,
      Msds,
      NumMsdsOrig,
      Msdsdoc,
      IndAnexMsds,

      @ObjectModel.text.element: ['StatusText']
      @UI.textArrangement: #TEXT_ONLY
      Status,
      StatusText,

      _Supplier.SupplierName                                                                           as SupplierShortName,
      _Supplier.SupplierFullName                                                                       as SupplierFullName,
      _Supplier.TaxNumber1                                                                             as SupplierCnpj,
      _Supplier.TaxNumber2                                                                             as SupplierCpf,
      _Supplier.BPAddrStreetName                                                                       as SupplierStreetName,
      SupplierCompanyName,
      _Supplier.DistrictName                                                                           as SupplierDistrictName,
      _Supplier.BPAddrCityName                                                                         as SupplierCityName,
      _Supplier.PostalCode                                                                             as SupplierPostalCode,
      _Supplier.Region                                                                                 as SupplierRegion,
      @ObjectModel.text.element: ['CountryName']
      _Supplier.Country                                                                                as SupplierCountry,
      _Country._Text[1:Language = $session.system_language].CountryName                                as CountryName,
      SupplierAddressID,
      _Supplier._AddressDefaultRepresentation[1:AddressID = $projection.supplieraddressid].HouseNumber as SupplierHouseNumber,
      //SupplierCountryName,
      _Supplier._CurrentDfltLandlinePhoneNmbr.PhoneNumberCountry                                       as SupplierInternationalPhoneCode,
      _Supplier.PhoneNumber1                                                                           as SupplierPhoneNumber,
      _Supplier.FaxNumber                                                                              as SupplierFaxNumber,
      SupplierBrazilPhoneCode,
      _Supplier.TaxNumber3                                                                             as SupplierStateTaxNumber,
      _Supplier.SupplierName                                                                           as SupplierName,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MAT_RME_CREATE_HIDDEN'
      EditHidden,

      Dataincl,
      Horaincl,

      /* Associations */
      _MatRme : redirected to parent ZC_MAT_RME
}
