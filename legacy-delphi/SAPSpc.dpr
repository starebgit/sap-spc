program SAPSpc;

uses
  Dialogs,
  Vcl.Forms,
  windows,
  zacetna in 'zacetna.pas' {Fzacetna},
  deklar in 'deklar.pas',
  sap in 'sap.pas' {Fsap},
  ComPort in 'ComPort.pas' {FcomPort},
  lokalBaza in 'lokalBaza.pas' {FlokalBaza},
  lokalmeritve in 'lokalmeritve.pas' {FlokalMeritve},
  postaje in 'postaje.pas' {Fpostaje},
  stroji in 'stroji.pas' {Fstroji},
  VpisStroj in 'VpisStroj.pas' {FvpisStroj},
  sinapro in 'sinapro.pas' {Fsinapro},
  SemafData in 'SemafData.pas' {Fsemafdata},
  semafor in 'semafor.pas' {Fsemafor},
  SqlKode in 'SqlKode.pas' {FsqlKode},
  IzborSrz in 'IzborSrz.pas' {FizborSrz},
  prekini in 'prekini.pas',
  metode in 'metode.pas' {Fmetode},
  VpisMetoda in 'VpisMetoda.pas' {Fvpismetoda},
  VpisKode in 'VpisKode.pas' {FVpisKode},
  VpisUkrep in 'VpisUkrep.pas' {FvpisUkrep},
  ukrepi in 'ukrepi.pas' {Fukrepi},
  VpisOpom in 'VpisOpom.pas' {FvpisOpom},
  sqlMeritve in 'sqlMeritve.pas' {FSqlMeritve},
  grafi in 'grafi.pas' {FGrafi},
  defKanal in 'defKanal.pas' {Fdefkanal},
  pass in 'pass.pas' {FPassw},
  CasDoba in 'CasDoba.pas' {FcasDoba},
  dodatKod in 'dodatKod.pas' {FDodatKod},
  VpisFrek in 'VpisFrek.pas' {FvpisFrek},
  legenda in 'legenda.pas' {Flegenda},
  Izborsarza in 'Izborsarza.pas' {FIzborSarza},
  VpisStev in 'VpisStev.pas' {FvpisStev},
  verzija in 'verzija.pas' {Fverzija},
  rezultati in 'rezultati.pas' {Frezultati},
  defAnaliza in 'defAnaliza.pas' {FDefAnaliza},
  verzije in 'verzije.pas' {Fverzije},
  DefFilter in 'DefFilter.pas' {FDefFilter},
  merila in 'merila.pas' {Fmerila},
  Vpismerila in 'Vpismerila.pas' {Fvpismerila},
  VpisDod in 'VpisDod.pas' {FVpisDod},
  PrijavaSAP in 'PrijavaSAP.pas' {FprijavaSAP},
  VpisPrijava in 'VpisPrijava.pas' {FVpisPrijava},
  BeriMeritve in 'BeriMeritve.pas' {FBeriMeritve};

{$R *.res}
var
  appMutex:THandle;
  ii : integer ;
begin
  appMutex := CreateMutex(nil,true,'MUTEX');
  if GetlastError <> 0 then
  begin
    Application.Terminate
  end ;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFzacetna, Fzacetna);
  Application.CreateForm(TFsap, Fsap);
  Application.CreateForm(TFcomPort, FcomPort);
  Application.CreateForm(TFlokalBaza, FlokalBaza);
  Application.CreateForm(TFlokalMeritve, FlokalMeritve);
  Application.CreateForm(TFpostaje, Fpostaje);
  Application.CreateForm(TFstroji, Fstroji);
  Application.CreateForm(TFvpisStroj, FvpisStroj);
  Application.CreateForm(TFsinapro, Fsinapro);
  Application.CreateForm(TFsemafdata, Fsemafdata);
  Application.CreateForm(TFsemafor, Fsemafor);
  Application.CreateForm(TFsqlKode, FsqlKode);
  Application.CreateForm(TFizborSrz, FizborSrz);
  Application.CreateForm(TFmetode, Fmetode);
  Application.CreateForm(TFvpismetoda, Fvpismetoda);
  Application.CreateForm(TFVpisKode, FVpisKode);
  Application.CreateForm(TFvpisUkrep, FvpisUkrep);
  Application.CreateForm(TFukrepi, Fukrepi);
  Application.CreateForm(TFvpisOpom, FvpisOpom);
  Application.CreateForm(TFSqlMeritve, FSqlMeritve);
  Application.CreateForm(TFGrafi, FGrafi);
  Application.CreateForm(TFdefkanal, Fdefkanal);
  Application.CreateForm(TFPassw, FPassw);
  Application.CreateForm(TFcasDoba, FcasDoba);
  Application.CreateForm(TFDodatKod, FDodatKod);
  Application.CreateForm(TFvpisFrek, FvpisFrek);
  Application.CreateForm(TFlegenda, Flegenda);
  Application.CreateForm(TFIzborSarza, FIzborSarza);
  Application.CreateForm(TFvpisStev, FvpisStev);
  Application.CreateForm(TFverzija, Fverzija);
  Application.CreateForm(TFrezultati, Frezultati);
  Application.CreateForm(TFDefAnaliza, FDefAnaliza);
  Application.CreateForm(TFverzije, Fverzije);
  Application.CreateForm(TFDefFilter, FDefFilter);
  Application.CreateForm(TFmerila, Fmerila);
  Application.CreateForm(TFvpismerila, Fvpismerila);
  Application.CreateForm(TFVpisDod, FVpisDod);
  Application.CreateForm(TFprijavaSAP, FprijavaSAP);
  Application.CreateForm(TFVpisPrijava, FVpisPrijava);
  Application.CreateForm(TFBeriMeritve, FBeriMeritve);
  Application.Run;
end.
