unit sap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SAPFunctionsOCX_TLB, Vcl.OleCtrls,
  SAPLogonCtrl_TLB,pomoc;

type
  karak = record
    poz : string ;
    naziv : string ;
    spmeja : string ;
    zgmeja : string ;
    predpis : string ;
    metoda : string ;
    stkan : Integer ;
    com : integer ;
    oznaka : string ;
    prer : string ;
    operac : string ;
    avr : single ;
    stand : single ;
    id : integer ;
    stevVz : Integer ;
  end;
  {karMer = record
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
  end;    }
  atrib = record
    poz : string ;
    naziv : string ;
    operac : string ;
    st_vzor : integer ;
    stevVz : Integer ;
  end;
 { rezultat = record
    vrednost : single ;
    dd : TdateTime ;
    tt : TdateTime ;
    vzorec : Integer
  end ;    }
  analiza = record
    koda : string ;
    sarza : string ;
    operac : string ;
    pozic : string ;
    naziv : string ;
    zacdat : TdateTime ;
    kondat : TdateTime ;
    predpis : single ;
    spmeja : single ;
    zgmeja : single ;
    dodatTol : single ;
  end;
  TFsap = class(TForm)
    SAPLogonControl1: TSAPLogonControl;
    SAPFunctions1: TSAPFunctions;
  private
    connection : variant ;
    plant : string ;
  //  procedure GetOperac ;
  //  function Getmat(mt,opr : string) : string ;
    procedure Prijava(var connection : variant) ;
    Function SarzaKontrol(tab: variant) : boolean ;
  public
    procedure GetKonsarza(kd : string; dat : TdateTime; preve :boolean;var listsrz : TstringList) ;
    procedure getkarakt(kd,srz : string; var listkar1,listkar2 : Tlist) ;
    procedure beriOperac(srz : string; var ListOpr : TstringList) ;
    function Zapis(srz,opr,nazivp,merl,odl,orod : string ; dd : TdateTime ; karlist,evalList : Tlist) : boolean ;
    procedure Pocistikr(list : Tlist) ;
    procedure Pocistiat(list : Tlist) ;
    Function preveriSar(srz: string) : boolean;
    //Procedure Getresult(srz,opr,poz : string ; dt1,dt2 : TdateTime; var listr : TList) ;
    Procedure Getresult(anl :analiza; var listr : TList) ;
  end;

var
  Fsap: TFsap;

implementation

{$R *.dfm}

uses sqlMeritve, deklar , metode, postaje, PrijavaSAP;


// procedura vrne listo operacij za dolèeno kontrolno šaržo
procedure TFSAP.beriOperac(srz : string; var ListOpr : TstringList) ;
  var funct : variant ;
      tabr : variant ;
      ii : Integer ;
begin
  Prijava(connection) ;
  if Connection.LogOn(0,true) = true then  (* parameter "true" = SilentLogOn *)
  begin
    SAPFunctions1.Connection := Idispatch(Connection);
    funct := sapFunctions1.add('BAPI_INSPLOT_GETOPERATIONS');
    funct.exports('NUMBER').value := srz ;
    funct.call ;
    tabr := funct.TABLES.item('INSPOPER_LIST');
    for ii := 1 to tabr.RowCount do ListOpr.add(tabr.value[ii,2] )
  end  ;
end;

// branje kontrolnega plana
procedure TFsap.getkarakt(kd,srz : string; var listkar1,listkar2 : Tlist) ;
    var ii,j,jj,kk,k : integer ;
      connection,funct,funct1 : variant ;
      spk,spt : string ;
      opr : string ;
      nkar : Integer ;
      tabv,tabl,tabn : variant ;
      pp : ^karak ;
      pk : ^atrib ;
      listopr : TstringList ;
      listr : Tlist ;
      avr,std : single ;
begin
  Listopr := Tstringlist.create ;
  beriOperac(srz,listOpr) ;
//  Screen.Cursor := crHourGlass ;
  Prijava(connection) ;
  if Connection.LogOn(0,true) = true then  (* parameter "true" = SilentLogOn *)
  begin
    for k := 0 to listOpr.Count-1 do       // po vseh operacijah
    begin
      opr := Listopr[k] ;

      SAPFunctions1.Connection := Idispatch(Connection);
      funct := sapFunctions1.add('BAPI_INSPOPER_GETDETAIL');
      funct.exports('INSPLOT').value := srz ;
      funct.exports('INSPOPER').value := opr ;
      funct.exports('READ_INSPPOINTS').value := 'X' ;
      funct.exports('READ_CHAR_REQUIREMENTS').value := 'X' ;
     // funct.exports('READ_SINGLE_RESULTS').value := 'X' ;
      //funct.exports('READ_CHAR_RESULTS').value := 'X' ;
      //funct.exports('READ_SAMPLE_RESULTS').value := 'X' ;
      funct.call ;
      tabv := funct.TABLES.item('INSPPOINTS');
      tabl := funct.TABLES.item('CHAR_REQUIREMENTS');
     // tabk := funct.TABLES.item('CHAR_RESULTS');
     // tabs := funct.TABLES.item('SINGLE_RESULTS');
     // tabN := funct.TABLES.item('SAMPLE_RESULTS');

      nkar := tabl.rowCount ;
      jj := 0 ;
      kk := 0 ;
      for j := 1 to nkar do
      begin
        spk := tabl.value[j,9] + '/' + tabl.value[j,10] ;
        spt :=  trim(tabl.value[j,45]) + '-' + trim(tabl.value[j,44]) ;
        if tabl.value[j,6] = '01' then      // variabilne karakteristike
        begin
          inc (jj) ;
          new(pp) ;
          pp^.poz := tabl.value[j,3] ;
          pp^.naziv := tabl.value[j,5] ;
          pp^.spmeja := trim(tabl.value[j,45]) ;
          pp^.zgmeja := trim(tabl.value[j,44]) ;
          pp^.predpis := trim(tabl.value[j,43]) ;
          pp^.metoda := trim(tabl.value[j,23]) ;
          pp^.operac := opr ;
          pp^.stevVz := tabl.value[j,14] ;
          pp^.stkan :=  Fmetode.getkanal(pp^.metoda) ;
          pp^.com := 0 ;
          listr := tlist.Create ;
          FsqlMeritve.getlist(kd,pp^.poz,listr);
          FsqlMeritve.Getstat(listr,avr,std)  ;
          pp^.avr := avr ;
          pp^.stand := std ;
          Cistigraf(listr) ;
          listkar1.Add(pp) ;
         // stcl := tabl.value[j,14] ;
        end else
        begin                       // atributivne karakteristike
          new(pk) ;
          pk^.stevVz := tabl.value[j,14]  ;
          pk^.poz :=  tabl.value[j,3] ;
          pk^.naziv :=  tabl.value[j,5] ;
          pk^.operac := opr ;
          listkar2.Add(pk) ;
        end;
      end;
      for j := 1 to Funct.Tables.Item('INSPPOINTS').rowcount do Funct.Tables.Item('INSPPOINTS').deleterow ;
      for j := 1 to Funct.Tables.Item('CHAR_REQUIREMENTS').rowcount do Funct.Tables.Item('CHAR_REQUIREMENTS').deleterow ;
    end;
    listOpr.Free ;
   end;
end;


// procedura pridobi kontrolno šaržo ( ali listo šarž) ;
procedure TFsap.GetKonsarza(kd : string; dat : TdateTime; preve :boolean; var listsrz : TstringList) ;
  var funct,funct1,tabc : variant ;
      j,ll : integer ;
      mat,tx,opr,srz : string ;
      bb,b1 : boolean ;
      ktex,saptex : string ;
begin
   ktex := Fpostaje.gettex ;
   Screen.Cursor := crHourGlass ;
   Prijava(connection) ;
   if Connection.LogOn(0,true) = true then  (* parameter "true" = SilentLogOn *)
   begin
      if kd <> '' then      // vpisana je bila koda izdelka
      begin
        tx := kd ;
       // opr := 'I' ;
       // mat := getmat(tx,opr) ;
        mat := koda18(trim(tx)) ;

        // pridobim listo kontrolnih šarž
        SAPFunctions1.Connection := Idispatch(Connection);
        funct := sapFunctions1.add('BAPI_INSPLOT_GETLIST');
        funct.exports('MATERIAL').value := mat ;
        funct.exports('PLANT').value := plant  ;
        funct.exports('CREAT_DAT').value := dat  ;
        funct.exports('STATUS_UD').value := ''   ;
        funct.exports('STATUS_RELEASED').value := 'X'   ;
        funct.exports('STATUS_CREATED').value := 'X'   ;
        funct.call ;
        tabc := funct.TABLES.item('INSPLOT_LIST');
        if tabc.rowcount > 0 then
        begin
          for j := 1 to tabc.rowCount do
          begin
            srz := tabc.value[j,1] ;
            if preve then
            begin
            saptex := tabc.value[j,12] ;
            if copy(saptex,1,2) = 'MM' then
            begin
              //if saptex = ktex then b1 := true else b1 := false
              b1 := true
            end else
            begin
              if ktex <> '' then b1 := false else b1 := true
            end;
            end else b1 := true ;
            bb := preverisar(srz) ;
            if bb and b1 then ListSrz.add(srz)
          end;
        end else
        begin
          //srz := '' ;
         // ShowMessage('Nisem našel nobene kontrolne šarže') ;
        end;
      end
   end else
     Showmessage('Prijava v SAP ni bila uspešna');
   Screen.Cursor := crDefault ;
end;

{function TFsap.Getmat(mt,opr : string) : string ;
  var funct1 : variant ;
begin
  result := koda18(trim(mt)) ;
  SAPFunctions1.Connection := Idispatch(Connection);
  funct1 := SAPFunctions1.add('ZRFC_CONV_MATNR_GET');
  funct1.exports('RFC_INPUT').value := mt ;
  funct1.exports('RFC_IO_KENNZ').value := opr ;
  Funct1.call ;
  result := funct1.imports('RFC_OUTPUT').value ;
end;  }



{procedure TFsap.GetOperac ;
  var i,j: Integer ;
      connection,funct,funct1,tabm : variant ;
      lista : TstringList ;
      listb : TstringList ;
      mt,stx : string ;
      storno : boolean ;
      srz : string ;
      tabr : variant ;
      //pz : ^sarz ;
begin
  //comboBox3.Items.Clear ;
  //srz := beriSarzo ;
//  Screen.Cursor := crHourGlass ;

  Prijava(connection) ;
  if Connection.LogOn(0,true) = true then  (* parameter "true" = SilentLogOn *)
  begin
      SAPFunctions1.Connection := Idispatch(Connection);
      funct1 := sapFunctions1.add('BAPI_INSPLOT_GETDETAIL');
      funct1.exports('NUMBER').value := srz ;
      funct1.exports('LANGUAGE').value[1] := 5  ;
      funct1.call ;

      // preverim ali je bila kont. šarža stronirana
      tabm := funct1.TABLES.ITEM('SYSTEM_STATUS');
      storno := false ;
      for j := 1 to tabm.rowcount do
      begin
        stx := tabm.value[j,1] ;
        if stx = 'I0224' then storno := true ;
      end;

      if storno then
      begin
        ShowMessage('Kontrolna šarža je stornirana') ;
        exit ;
      end;

      // preberem operacije in jih zapišem v list box
      SAPFunctions1.Connection := Idispatch(Connection);
      funct := sapFunctions1.add('BAPI_INSPLOT_GETOPERATIONS');
      funct.exports('NUMBER').value := srz ;
      funct.call ;
      tabr := funct.TABLES.item('INSPOPER_LIST');

      for i := 1 to tabr.rowcount do
      begin
        //  edit1.Text := tabc.value[1,13] ;
        //combobox3.Items.Add(tabr.value[i,2]) ;
          //srza :=  tabc.value[1,12]
      end ;
     // opr := tabr.value[1,2] ;
     // opr1 := tabr.value[1,4] ;

   end;
   //Screen.Cursor := crDefault ;
end;
}
// izvedba zapisa v SAP
function TFSAP.Zapis(srz,opr,nazivp,merl,odl,orod : string ; dd : TdateTime ; karlist,evalList : Tlist) : boolean ;
  var funct,funct1 : variant ;
      tab,tabb : variant ;
      dniz,tniz : string ;
      dt,tm :TdateTime ;
      kk,j,ll : integer ;
      pv : ^karmer ;
      px : ^evaluac ;
      stkr,skpp,stip,opom,dbred,merit,slabi : string ;
      stmr : integer ;
      vredu : boolean ;
      mm : integer ;
begin
  dniz := DateTostr(dd) ;
  dt := NizTodatum(dniz) ;
  tniz := TimeTostr(dd) ;
  tm := StrToTime(tniz) ;
  Prijava(connection) ;
  if Connection.LogOn(0,true) = true then  (* parameter "true" = SilentLogOn *)
  begin
     SAPFunctions1.Connection := Idispatch(Connection);
     funct := sapFunctions1.add('BAPI_INSPOPER_RECORDRESULTS');
     funct.exports('INSPLOT').value := srz ;
     funct.exports('INSPOPER').value := opr ;
     funct.exports('INSPPOINTDATA').value(1) := srz ;
     funct.exports('INSPPOINTDATA').value(2) := opr ;
     funct.exports('INSPPOINTDATA').value(12) := nazivp ;
     //funct.exports('INSPPOINTDATA').value(12) := orod ;
     funct.exports('INSPPOINTDATA').value(28) := merl ;
     funct.exports('INSPPOINTDATA').value(16) := dt;
     funct.exports('INSPPOINTDATA').value(17) := tm ;
     funct.exports('INSPPOINTDATA').value(18) := '3' ;
     funct.exports('INSPPOINTDATA').value(19) := plant ;
     funct.exports('INSPPOINTDATA').value(20) := 'A/R' ;
     funct.exports('INSPPOINTDATA').value(21) := 'A/R' ;
     funct.exports('INSPPOINTDATA').value(22) := odl ;
     funct.exports('INSPPOINTDATA').value(23) := orod ;

     mm := 1 ;
     for kk := 1 to karlist.count do
   //   for kk := 1 to 1 do
     begin
       pv := karlist[kk-1] ;
       stkr := pv^.stkar ;
       stmr := pv^.stmer ;
       skpp := pv^.skupi ;
       stip := pv^.tip ;
       dbred := pv^.eval ;
       opom := pv^.opom ;
       merit := pv^.merit ;
       funct.TABLES.Item('CHAR_RESULTS').APPENDROW.Value('INSPLOT'):= srz;
       Funct.Tables.Item('CHAR_RESULTS').Value[kk,2] := opr ;
       Funct.Tables.Item('CHAR_RESULTS').Value[kk,3] := stkr;  ;
       Funct.Tables.Item('CHAR_RESULTS').Value[kk,25] := opom;
       Funct.Tables.Item('CHAR_RESULTS').Value[kk,23] := merl;

       if skpp = 'X' then        // Posamezen vnos
       begin
         funct.TABLES.Item('SINGLE_RESULTS').APPENDROW.Value('INSPLOT'):= srz;
         Funct.Tables.Item('SINGLE_RESULTS').Value[kk,2] := opr ;
         Funct.Tables.Item('SINGLE_RESULTS').Value[kk,3] := stkr ;
         Funct.Tables.Item('SINGLE_RESULTS').Value[kk,4] := stmr ;
         Funct.Tables.Item('SINGLE_RESULTS').Value[kk,5] := kk ;
         Funct.Tables.Item('SINGLE_RESULTS').Value[kk,7] := 'X' ;
         Funct.Tables.Item('SINGLE_RESULTS').Value[kk,16] := merl;
         if stip = '02' then
             Funct.Tables.Item('SINGLE_RESULTS').Value[kk,13] := dbred
         else
             Funct.Tables.Item('SINGLE_RESULTS').Value[kk,10] := merit ;

         funct.Tables.Item('CHAR_RESULTS').Value[kk,4] := 'X' ;
         Funct.Tables.Item('CHAR_RESULTS').Value[kk,5] := 'X' ;
         Funct.Tables.Item('CHAR_RESULTS').Value[kk,8] := dbred;
         Funct.Tables.Item('CHAR_RESULTS').Value[kk,15] := merit ;
         Funct.Tables.Item('CHAR_RESULTS').Value[kk,25] := opom ;

         if pv^.stevnp = 1  then
         begin
          funct.TABLES.Item('SAMPLE_RESULTS').APPENDROW.Value('INSPLOT'):= srz;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,2] := opr ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,3] := stkr ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,4] := kk ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,6] := 'X' ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,7] := 'X' ;
        //  Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,13] := slabi ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,25] := merl;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,27] := opom;
          inc(mm)
         end;
        // Funct.Tables.Item('CHAR_RESULTS').Value[kk,21] := date ;
        // Funct.Tables.Item('CHAR_RESULTS').Value[kk,22] := time ;
       end else
       begin
          for ll := 0 to evalList.count-1 do
          begin
            px := evalList[ll] ;
            if px^.stkar = stkr then
            begin
              dbred := px^.ev  ;
              slabi := IntTostr(px^.st) ;
            end;
          end;
        //  dbred := 'A' ;
        //  slabi := '0' ;


          funct.TABLES.Item('SAMPLE_RESULTS').APPENDROW.Value('INSPLOT'):= srz;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,2] := opr ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,3] := stkr ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,4] := kk ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,6] := 'X' ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,7] := 'X' ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,13] := slabi ;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,25] := merl;
          Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,27] := opom;


       //   Funct.Tables.Item('SAMPLE_RESULTS').Value[m1,13] := pv^.stevnp ;
          if stip = '02' then
          begin
             Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,10] := dbred  ;
             Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,28] := dbred  ;
             Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,29] := 'A/R'  ;
          end
          else
             Funct.Tables.Item('SAMPLE_RESULTS').Value[mm,17] := merit ;

          Funct.Tables.Item('CHAR_RESULTS').Value[mm,4] := 'X' ;
          Funct.Tables.Item('CHAR_RESULTS').Value[mm,5] := 'X' ;
          Funct.Tables.Item('CHAR_RESULTS').Value[mm,8] := dbred;
          Funct.Tables.Item('CHAR_RESULTS').Value[mm,13] := slabi ;
          Funct.Tables.Item('CHAR_RESULTS').Value[mm,15] := merit ;
          Funct.Tables.Item('CHAR_RESULTS').Value[mm,25] := opom ;
          Inc(mm)
        end;

        //FSqltable.VpisChr(izap,kk,stkr,skpp,stip,pb^.merit,dbred,pb^.opom) ;
      end ;
      if not funct.call then showmessage('Ni v redu');
      tab := funct.imports.item('RETURN');
      tabb := funct.tables.Item('RETURNTABLE') ;
      if tab.value[1] = 'E' then vredu := false else vredu := true;
      if tabb.rowcount > 0 then
          // Showmessage(tabb.value[1,1] + '/' + tabB.value[1,4] + '/' + tab.value[8]) ;
           Showmessage(tabb.value[1,1] + '/' + tabB.value[1,4] ) ;
      if vredu then
      begin
          SAPFunctions1.Connection := Idispatch(Connection);
          funct1 := sapFunctions1.add('BAPI_TRANSACTION_COMMIT');
          if not funct1.call then
          begin
            showMessage(Funct1.exception) ;
            result := false ;
          end else
            result := true
      end else result := false ;
     for j := 1 to Funct.Tables.Item('CHAR_RESULTS').rowcount do Funct.Tables.Item('CHAR_RESULTS').deleterow ;
     for j := 1 to Funct.Tables.Item('SINGLE_RESULTS').rowcount do Funct.Tables.Item('SINGLE_RESULTS').deleterow ;
     for j := 1 to Funct.Tables.Item('SAMPLE_RESULTS').rowcount do Funct.Tables.Item('SAMPLE_RESULTS').deleterow ;
  end else
  begin
    result := false ;
    ShowMessage('Prijava v SAP ni uspela')
  end;
end;


// prijava v SAP sistem
procedure TFSAp.Prijava(var connection : variant) ;
  var prija : Tprijava ;
begin
  FPrijavaSAP.getPrijava(prija) ;
 // FPrijavaSAP.getNew(prija) ;
  if trim(prija.upo) = 'rsg_rfc_1' then plant := '0401' else plant := '1061' ;
  Connection := SAPLogoncontrol1.newConnection;
 with prija do
  begin
    Connection.User              := trim(upo) ;
    Connection.System            := trim(sistem);
    Connection.Client            := trim(cli);
  //  Connection.ApplicationServer := 'sapr3.egoproducts.com';
    Connection.ApplicationServer := trim(applic);
    Connection.SystemNumber      := IntTostr(sisnum) ;
    Connection.Password          := trim(ges);
    Connection.Language          := trim(jezik) ;
  end ;
 { //showmessage(prija.sistem) ;
   Connection                   := SAPLogoncontrol1.newConnection;
 // Connection.User              := 'boncinar' ;
  Connection.User              := 'rsg_rfc_1' ;
// Connection.System            := 'E01';
   Connection.System            := 'Q01';
  Connection.Client            := '101';
 // Connection.ApplicationServer := '10.0.2.159';
  Connection.ApplicationServer := '10.0.2.212';
 //  Connection.ApplicationServer := 'sapq01.egoproducts.com';
//  Connection.SystemNumber      := '00';
 Connection.SystemNumber      := '20';

    Connection.Password          := 'khg+987w';
  Connection.Language          := 'sl'    }
end ;


// funkcija preveri ali je kontrolna šarža odprta
Function TFsap.preveriSar(srz: string) : boolean;
  var funct1,tabm : variant ;
      i : integer ;
      insp : string ;
begin
  Prijava(connection) ;
  if Connection.LogOn(0,true) = true then  (* parameter "true" = SilentLogOn *)
  begin
      SAPFunctions1.Connection := Idispatch(Connection);
      funct1 := sapFunctions1.add('BAPI_INSPLOT_GETDETAIL');
      funct1.exports('NUMBER').value := srz ;
      funct1.exports('LANGUAGE').value[1] := 5  ;
      funct1.call ;

      insp := funct1.imports('GENERAL_DATA').value[11] ;
      if insp = '' then result := false
      else begin
        tabm := funct1.TABLES.ITEM('SYSTEM_STATUS');
        result := SarzaKontrol(tabm) ;
      end;
  end;
end;


// procedura vrne listo rezultatov meritev
Procedure TFsap.Getresult(anl :analiza; var listr : TList) ;
  var funct,tabb,funct1,tabn : variant ;
      mx,zc,ii,kk,jj : integer ;
      pp : ^rezultat ;
      dt : TdateTime ;
begin
  Prijava(connection) ;
  if Connection.LogOn(0,true) = true then  (* parameter "true" = SilentLogOn *)
  begin
     SAPFunctions1.Connection := Idispatch(Connection);
     funct := sapFunctions1.add('BAPI_INSPPOINT_GETLIST');
     funct.exports('INSPLOT').value := anl.sarza ;
     funct.exports('INSPOPER').value := anl.operac ;

     if not funct.call then exit ;
     tabb := funct.TABLES.item('INSPPOINT_LIST');

     for ii := 1 to  tabb.rowcount do
     begin
       dt := tabb.value[ii,26] ;
       if (dt >= anl.zacdat) and (dt <= anl.kondat) then
       begin
         kk := tabb.value[ii,3] ;
         SAPFunctions1.Connection := Idispatch(Connection);
         funct1 := sapFunctions1.add('BAPI_INSPCHAR_GETRESULT');
         funct1.exports('INSPLOT').value := anl.sarza ;
         funct1.exports('INSPOPER').value := anl.operac ;
         funct1.exports('INSPCHAR').value := anl.pozic ;

         funct1.exports('INSPSAMPLE').value := kk ;

         funct1.call ;
         tabn := funct1.TABLES.item('SINGLE_RESULTS');
         for jj := 1 to tabn.rowcount do
         begin
           dt := tabn.value[jj,8] ;
          // if (dt >= dt1) and (dt <= dt2) then
           begin
             new(pp) ;
             pp^.vrednost := tabn.value[jj,10] ;
             pp^.tt := tabn.value[jj,9] ;
             pp^.dd := dt;
             listr.add(pp)
           end;
         end;

        for jj := 1 to tabn.rowcount do tabn.deleterow ;
       end;
     end;
     for ii := 1 to tabb.rowcount do tabb.deleterow ;
  end;
end;


// funkcija na podalgi statusa odloèi ali je kontrolna šarža odprta
Function TFsap.SarzaKontrol(tab: variant) : boolean ;
  var rw : integer ;
      ii,ix  : integer ;
begin
  rw := tab.rowcount ;
  ix := 0 ;
  for ii := 1 to rw do
  begin
    if tab.value[ii,2] = 'DOPS' then inc(ix) ;
    if tab.value[ii,2] = 'LANS' then inc(ix) ;
    if tab.value[ii,2] = 'KAKK' then inc(ix) ;
    if tab.value[ii,2] = 'SERS' then ix := ix-1;
  end;
  if ix = 3 then result := true else result := false ;
end ;

procedure TFSAp.Pocistikr(list : Tlist) ;
  var i : integer ;
      pp : ^karak ;
begin
  if assigned(list) then
  begin
    for i := 0 to (List.Count - 1) do
    begin
      pp := List[i];
      Dispose(pp);
    end;
    List.Free ;
  end;
end;

procedure TFSAp.Pocistiat(list : Tlist) ;
  var i : integer ;
      pp : ^atrib ;
begin
  if assigned(list) then
  begin
    for i := 0 to (List.Count - 1) do
    begin
      pp := List[i];
      Dispose(pp);
    end;
    List.Free ;
  end;
end;


end.
