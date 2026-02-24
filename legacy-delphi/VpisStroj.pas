unit VpisStroj;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, sinapro, deklar;

type
  TFvpisStroj = class(TForm)
    Panel1: TPanel;
    List1: TListBox;
    List2: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    List3: TListBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
    procedure List1Click(Sender: TObject);
    procedure List2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    listEnote : Tlist ;
    listSkup : Tlist ;

    procedure FillDelEnote ;
    procedure FillDelavnice ;
    procedure FillStroji ;
  public
    listStroji : Tlist ;
    procedure  Vpis ;
    procedure test ;
  end;

var
  FvpisStroj: TFvpisStroj;

implementation

{$R *.dfm}

procedure TFvpisStroj.FormActivate(Sender: TObject);
begin
   //FillDelEnote ;
end;

procedure TFvpisStroj.List1Click(Sender: TObject);
begin
  FillDelavnice ;
end;

procedure TFvpisStroj.List2Click(Sender: TObject);
begin
  FillStroji ;
end;

procedure TFvpisStroj.test ;
begin
  //if assigned(listskup) then SHowmessage(IntTostr(listskup.count)) ;
end;

procedure  TFVpisStroj.Vpis ;
begin
 //  if assigned(listskup) then SHowmessage(IntTostr(listskup.count)) ;
   List1.Items.Clear ;
   List2.Items.Clear ;
   List3.Items.Clear ;

   FillDelEnote ;

   showModal ;
   Pocisti1(ListEnote) ;
   pocisti1(listSkup) ;
  //  if assigned(listskup) then SHowmessage('a'+IntTostr(listskup.count)) ;
end;

procedure TFvpisStroj.FillDelEnote ;
  var pp : ^zapis ;
      ii : integer ;
begin
   ListEnote := Tlist.create ;
   Fsinapro.getenote(listenote) ;
   for ii := 0 to listenote.Count-1   do
   begin
     pp := listenote[ii] ;
     List1.Items.Add(pp^.naziv) ;
  end;
end;

procedure TFvpisStroj.Button1Click(Sender: TObject);
  var ii : Integer ;
      pp : ^zapis ;
begin
  for ii := 0 to list3.Items.count-1 do
  begin
    if list3.selected[ii] then
    begin
      pp := listStroji[ii] ;
      pp^.izbran := true ;
    end;
  end;
  close ;

end;

procedure TFvpisStroj.Button2Click(Sender: TObject);
begin
  Close ;
end;

procedure TFvpisStroj.FillDelavnice ;
  var ii : integer ;
      pp : ^zapis ;
      ident : integer ;
begin
   //Delavnice.Caption := 'Delavnice' ;
   ii := List1.ItemIndex ;
   pp := ListEnote[ii] ;
   ident := pp^.ident ;
  // Pocisti1(ListSkup) ;
   ListSkup := Tlist.Create ;
   Fsinapro.getDelavnice(ident,ListSkup);

   List2.Items.Clear ;
   for ii := 0 to listSkup.count-1  do
   begin
     pp := ListSkup[ii] ;
     List2.Items.Add(pp^.naziv) ;
   end;

end;


procedure TFvpisStroj.FillStroji ;
  var ii : integer ;
      pp : ^zapis ;
      ident : integer ;
      str : int64 ;
begin
   //Label2.Caption := 'Stroji' ;
   ii := List2.ItemIndex ;
   pp := ListSkup[ii] ;
   ident := pp^.ident ;
 //  Pocisti1(ListStroji) ;

   Fsinapro.GetStroji(ident,ListStroji) ;

   List3.Items.Clear ;
   for ii := 0 to ListStroji.Count-1  do
   begin
     pp := listStroji[ii] ;
     List3.Items.Add(pp^.naziv) ;
   end;

end;


end.
