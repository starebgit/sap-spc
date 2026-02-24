unit deklar;

interface

uses System.Classes, System.SysUtils, System.Variants,dialogs, vcl.Forms ;

type
  zapis = record
    ident : int64 ;
    naziv : string ;
    vrednost : single ;
    izbran : boolean ;
    koda : string ;
    diff : integer ;
    traj : integer ;
  end ;

  karMer = record
    stkar : string ;
    imekar : string ;
    stmer : integer ;
    skupi : string ;
    tip : string ;
    merit : string  ;
    eval : string ;
    opom : String ;
    stevnp : integer ;
    stevilvz : Integer ;
  end;
  evaluac = record
     stkar : string ;
     imekar : string ;
     ev : string ;
     st : integer ;
     op : string ;
  end;

  rezultat = record
    vrednost : single ;
    dd : TdateTime ;
    tt : TdateTime ;
    vzorec : Integer
  end ;

  Tprijava = record
    sistem : string ;
    cli : string ;
    applic : string ;
    sisnum : integer ;
    upo : string ;
    ges : string ;
    jezik : string ;
    def : boolean ;
  end;

  procedure Pocisti1(var list : Tlist) ;
  procedure  cistiList1(var karlist : tlist)  ;
  procedure  cistiListE(var evallist : tlist) ;
  procedure cistigraf(var listr : tlist) ;
  procedure PisiLog(logtxt : string) ;
 // procedure Pocisti1(list : Tlist) ;
implementation


procedure Pocisti1(var list : Tlist) ;
  type
    pzapis = ^zapis ;
  var i : integer ;
      pp : ^zapis ;
      bb : boolean ;
begin
  bb := true ;
  if assigned(list) then
  begin
    for i := 0 to (List.Count - 1) do
    begin
      try
        //  pp := List[i];
        //  Dispose(pp);
        Dispose(Pzapis(list[i])) ;
        bb := true ;
      except
      //  showmessage('napaka')
      end;
    end;
    if bb then List.free ;
//    list := nil
  end;
end;

procedure  cistiList1(var karlist : tlist)  ;
  var i : integer ;
      pv : ^karmer ;
begin
    if assigned(karlist) then
    begin
      for i := 0 to (karlist.Count - 1) do
      begin
        pv := karlist[i];
        Dispose(pv);
      end;
      karlist.Free ;
    end;
end;

procedure  cistiListE(var evallist : tlist) ;
    var i : integer ;
        px : ^evaluac ;
begin
    if assigned(evallist) then
    begin
      for i := 0 to (evallist.Count - 1) do
      begin
        px := evallist[i];
        Dispose(px);
      end;
      evallist.Free ;
    end;
end;

procedure cistigraf(var listr : tlist) ;
    var i : integer ;
        px : ^rezultat ;
begin
    if assigned(listr) then
    begin
      for i := 0 to (listr.Count - 1) do
      begin
        px := listr[i];
        Dispose(px);
      end;
      listr.Free ;
    end;
end;


procedure PisiLog(logtxt : string) ;
  var ff : textfile ;
      imef : string ;
begin
  imef := ExtractFilePath(application.ExeName) + '\log.txt'  ;
  AssignFile(ff, imef);
  Append(ff);
  Writeln(ff, dateTimeTostr(now) + '   ' + logtxt) ;
  Flush(ff);
  CloseFile(ff);
end;


end.
