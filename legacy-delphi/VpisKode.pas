unit VpisKode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, sap, pomoc;

type
  TFVpisKode = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Panel2: TPanel;
    Button1: TButton;
    List1: TListBox;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    procedure Edit1Exit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    zapis : boolean ;
    procedure setListsrz;
  public
     Procedure Vpis(kd : string) ;
  end;

var
  FVpisKode: TFVpisKode;

implementation

{$R *.dfm}

uses sqlkode ;

procedure TFVpisKode.Button1Click(Sender: TObject);
  var kd ,srz : string ;
      ii : integer ;
      frk,trj : integer ;
begin
  zapis := true ;
  kd := edit1.Text ;
  frk := strToIntDef(edit2.Text,120) ;
  trj := strToIntDef(edit3.Text,15) ;
  ii := list1.ItemIndex ;
  if ii >= 0 then
  begin
    srz := list1.items[ii] ;
    FSqlKode.Zapis(kd,srz,frk,trj) ;
    FsqlKode.Prenoskar(srz) ;
    edit1.Text := '' ;
  end;
  List1.Items.Clear ;
end;

procedure TFVpisKode.Edit1Exit(Sender: TObject);
  var kd : string ;
      dat : TdateTime ;
      listsrz : TstringList ;
begin
  setlistsrz ;
end;

procedure TFVpisKode.setListsrz;
  var kd : string ;
      dat : TdateTime ;
      listsrz : TstringList ;
      bb : boolean ;
begin
  kd := edit1.Text ;
  dat := NizToDatum('01.01.2019') ;
  listsrz := TstringList.Create ;
  bb := checkbox1.checked ;
  Fsap.Getkonsarza(kd,dat,bb,listsrz) ;
  List1.Items := listsrz ;
  Listsrz.Free ;
end;



procedure TFVpisKode.Vpis(kd : string);
begin
  zapis := false ;
  list1.Items.Clear ;
  checkbox1.checked := true ;
  edit1.Text := kd ;
  if kd <> '' then setlistsrz ;
  showModal ;
end;

end.
