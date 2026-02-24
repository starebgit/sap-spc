unit prekini;

interface

uses
  System.Classes, System.SysUtils, dialogs;

type
  Tprekini = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;
   var
    stopal : Tprekini ;
implementation

 uses zacetna,ComPort,lokalBaza,postaje ;
{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure Tprekini.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

{ Tprekini }

procedure Tprekini.Execute;
 var row,col,rw,stm: Integer ;
     mtd,cm : string ;
     listk : Tlist ;
     pp : ^Merkanal ;
     ii : integer ;
     ids,dd : Integer ;
     posb : boolean ;
begin
 with Fzacetna do
 begin
   row := Karakti.Row ;
   col := karakti.Col ;
  // cm := karakti.Cells[6,row] ;
   if lokalb then cm := karakti.Cells[6,row] else cm := Fpostaje.getcom;
   if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
 //  std := spinedit2.Value ;
 //  stk := spinEdit1.value ;
   mtd := Karakti.Cells[5,row] ;
   if mtd = '' then exit ;

   rw := row ;
   stm := 1 ;
   listk := Tlist.Create ;
   while rw < karakti.RowCount-1 do
   begin
     inc(rw) ;
     if mtd <> Karakti.Cells[5,rw]  then
     begin
       new(pp) ;


       pp^.kanal := stkanal ;
       pp^.stmeritev := stm ;
       pp^.posebnost := posb ;
       listk.add(pp) ;
      // Showmessage(inttostr(stk) + '/'+ inttostr(stm)) ;
       stm := 0
     end;
     posb := false ;
     if lokalb then
       begin
         ids := StrToint(karakti.Cells[8,rw]) ;
         dd := round(Flokalbaza.Getpreracun(ids)) ;
         if dd = 0 then
         begin
           posb := true ;
           stm := 0 ;
         end;
       end;
     mtd := Karakti.Cells[5,rw] ;
     stkanal := StrToInt(mtd) ;
     inc(stm) ;
   end;
   new(pp) ;
   pp^.kanal := stkanal ;
   pp^.stmeritev := stm ;
   pp^.posebnost := posb ;
   listk.add(pp) ;
  // Showmessage(inttostr(listk.Count)) ;
   Button11.enabled := false ;
 //  Button5.enabled := false ;
 //  Button14.enabled := false ;
   if lokalb then FComPort.preberi4(row,col,stdec,cm,listk)
             else FComPort.preberi2(row,col,stdec,cm,listk) ;
   for ii := 0 to (listk.Count - 1) do
   begin
        pp := listk[ii];
        Dispose(pp);
   end;
   listk.Free ;
  Button11.enabled := true ;
 // Button5.enabled := true ;
 end;
end;

end.
