unit _ga2d;

interface

type
  TGA2DObject = class //base
  protected
    function GetElmt( idx: integer ): real; virtual; abstract;
  public
    function add( opd: TGA2DObject ): TGA2DObject; virtual; abstract;
    function sub( opd: TGA2DObject ): TGA2DObject; virtual; abstract;
    function mul( opd: TGA2DObject ): TGA2DObject; virtual; abstract;
    function mag: real; virtual; abstract;  //magnitude
    procedure nor; virtual; abstract; //normalize
    procedure neg; virtual; abstract;
    property Elmt[idx: integer]: real read GetElmt;
  end;

  TGA2Ds = class( TGA2DObject ) //scalar
  protected
    FValue: real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( value: real = 0 );
    function add( opd: TGA2DObject ): TGA2DObject; override;
    function sub( opd: TGA2DObject ): TGA2DObject; override;
    function mul( opd: TGA2DObject ): TGA2DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure neg; override;
  end;

  TGA2Dv = class( TGA2DObject ) //homogenous vector
  protected
    FValue: array[0..1] of real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( e1, e2: real );
    function add( opd: TGA2DObject ): TGA2DObject; override;
    function sub( opd: TGA2DObject ): TGA2DObject; override;
    function mul( opd: TGA2DObject ): TGA2DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure neg; override;
  end;

  TGA2Dbv = class( TGA2DObject ) //homogeneous bivector
  protected
    FValue: real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( e12: real );
    function add( opd: TGA2DObject ): TGA2DObject; override;
    function sub( opd: TGA2DObject ): TGA2DObject; override;
    function mul( opd: TGA2DObject ): TGA2DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure neg; override;
  end;

  TGA2Dmv = class( TGA2DObject ) //generic multivector
  protected
    FValue: array[0..3] of real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( e0, e1, e2, e12: real );
    function add( opd: TGA2DObject ): TGA2DObject; override;
    function sub( opd: TGA2DObject ): TGA2DObject; override;
    function mul( opd: TGA2DObject ): TGA2DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure neg; override;
  end;

  TGA2Dc = class( TGA2DObject ) //complex number
  protected
    FValue: array[0..1] of real;
    function GetElmt( idx: integer ): real; override;
  public
    constructor Create( e0, e12: real );
    function add( opd: TGA2DObject ): TGA2DObject; override;
    function sub( opd: TGA2DObject ): TGA2DObject; override;
    function mul( opd: TGA2DObject ): TGA2DObject; override;
    function mag: real; override;
    procedure nor; override;
    procedure neg; override;
  end;

implementation

{ TGA2Ds }

function TGA2Ds.add( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2ds then begin
    result := tga2ds.Create( FValue + opd.Elmt[0] );
  end
  else begin
    result := tga2dmv.Create( FValue + opd.Elmt[0], opd.Elmt[1], opd.Elmt[2], opd.Elmt[3] );
  end;
end;

constructor TGA2Ds.Create( value: real );
begin
  FValue := value;
end;

function TGA2Ds.GetElmt( idx: integer ): real;
begin
  if idx = 0 then
    result := fvalue
  else
    result := 0;
end;

function TGA2Ds.mag: real;
begin
  result := abs( fvalue );
end;

function TGA2Ds.mul( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2ds then begin
    result := tga2ds.Create( FValue * opd.Elmt[0] );
  end
  else
    if opd is tga2dv then
      result := tga2dv.Create( FValue * opd.Elmt[1], FValue * opd.Elmt[2] )
    else
      if opd is tga2dbv then
        result := tga2dbv.Create( FValue * opd.Elmt[3] )
      else
        if opd is tga2dc then
          result := tga2dc.Create( FValue * opd.Elmt[0], fvalue * opd.Elmt[3] )
        else
          result := tga2dmv.Create( FValue * opd.Elmt[0], FValue * opd.Elmt[1], FValue * opd.Elmt[2], FValue * opd.Elmt[3] );
end;

procedure TGA2Ds.neg;
begin
  inherited;
  fvalue := -fvalue;
end;

procedure TGA2Ds.nor;
begin
  inherited;
  fvalue := 1;
end;

function TGA2Ds.sub( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2ds then begin
    result := tga2ds.Create( FValue - opd.Elmt[0] );
  end
  else begin
    result := tga2dmv.Create( FValue - opd.Elmt[0], -opd.Elmt[1], -opd.Elmt[2], -opd.Elmt[3] );
  end;
end;

{ TGA2Dv }

function TGA2Dv.add( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2dv then
    result := tga2dv.Create( FValue[0] + opd.Elmt[1], FValue[1] + opd.Elmt[2] )
  else
    result := tga2dmv.Create( opd.Elmt[0], FValue[0] + opd.Elmt[1], FValue[1] + opd.Elmt[2], opd.Elmt[3] );
end;

constructor TGA2Dv.Create( e1, e2: real );
begin
  FValue[0] := e1;
  FValue[1] := e2;
end;

function TGA2Dv.GetElmt( idx: integer ): real;
begin
  if idx in [1, 2] then
    result := FValue[idx - 1]
  else
    result := 0;
end;

function TGA2Dv.mag: real;
begin
  result := sqrt( fvalue[0] * fvalue[0] + fvalue[1] * fvalue[1] );
end;

function TGA2Dv.mul( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2ds then
    result := opd.mul( self )
  else
    if opd is tga2dv then
      result := tga2dmv.Create( ( FValue[0] * opd.Elmt[1] + FValue[1] * opd.Elmt[2] ), 0, 0, ( FValue[0] * opd.Elmt[2] - FValue[1] * opd.Elmt[1] ) )
    else
      if opd is tga2dbv then
        result := tga2dv.Create( -FValue[1] * opd.Elmt[3], FValue[0] * opd.Elmt[3] )
      else
        if opd is tga2dc then
          result := tga2dv.Create(
            ( FValue[0] * opd.Elmt[0] - FValue[1] * opd.Elmt[3] ),
            ( FValue[0] * opd.Elmt[3] + FValue[1] * opd.Elmt[0] )
            )
        else
          result := tga2dmv.Create(
            ( FValue[0] * opd.Elmt[1] + FValue[1] * opd.Elmt[2] ),
            ( FValue[0] * opd.Elmt[0] - FValue[1] * opd.Elmt[3] ),
            ( FValue[0] * opd.Elmt[3] + FValue[1] * opd.Elmt[0] ),
            ( FValue[0] * opd.Elmt[2] - FValue[1] * opd.Elmt[1] ) );
end;

procedure TGA2Dv.neg;
begin
  inherited;
  fvalue[0] := -fvalue[0];
  fvalue[1] := -fvalue[1];
end;

procedure TGA2Dv.nor;
var
  len               : real;
begin
  inherited;
  len := mag;
  if len > 1E-3 then begin
    fvalue[0] := fvalue[0] / len;
    fvalue[1] := fvalue[1] / len;
  end;
end;

function TGA2Dv.sub( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2dv then
    result := tga2dv.Create( FValue[0] - opd.Elmt[1], FValue[1] - opd.Elmt[2] )
  else
    result := tga2dmv.Create( -opd.Elmt[0], FValue[0] - opd.Elmt[1], FValue[1] - opd.Elmt[2], -opd.Elmt[3] );
end;

{ TGA2Dbv }

function TGA2Dbv.add( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2dbv then
    result := tga2dbv.Create( fvalue + opd.Elmt[3] )
  else
    result := tga2dmv.Create( opd.Elmt[0], opd.Elmt[1], opd.Elmt[2], fvalue + opd.Elmt[3] );
end;

constructor TGA2Dbv.Create( e12: real );
begin
  FValue := e12;
end;

function TGA2Dbv.GetElmt( idx: integer ): real;
begin
  if idx = 3 then
    result := fvalue
  else
    result := 0;
end;

function TGA2Dbv.mag: real;
begin
  result := abs( fvalue );
end;

function TGA2Dbv.mul( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2ds then
    result := opd.mul( self )
  else
    if opd is tga2dv then
      result := tga2dv.Create( fvalue * opd.Elmt[2], -fvalue * opd.Elmt[1] )
    else
      if opd is tga2dbv then
        result := tga2ds.Create( -fvalue * opd.Elmt[3] )
      else
        if opd is tga2dc then
          result := tga2dc.Create( -fvalue * opd.Elmt[3], fvalue * opd.Elmt[0] )
        else
          result := tga2dmv.Create( -fvalue * opd.Elmt[3], fvalue * opd.Elmt[2], -fvalue * opd.Elmt[1], fvalue * opd.Elmt[0] );
end;

procedure TGA2Dbv.neg;
begin
  inherited;
  fvalue := -fvalue;
end;

procedure TGA2Dbv.nor;
begin
  inherited;
  fvalue := 1;
end;

function TGA2Dbv.sub( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2dbv then
    result := tga2dbv.Create( fvalue - opd.Elmt[3] )
  else
    result := tga2dmv.Create( -opd.Elmt[0], -opd.Elmt[1], -opd.Elmt[2], fvalue - opd.Elmt[3] );
end;

{ TGA2Dmv }

function TGA2Dmv.add( opd: TGA2DObject ): TGA2DObject;
begin
  result := tga2dmv.Create( FValue[0] + opd.Elmt[0], FValue[1] + opd.Elmt[1], FValue[2] + opd.Elmt[2], FValue[3] + opd.Elmt[3] );
end;

constructor TGA2Dmv.Create( e0, e1, e2, e12: real );
begin
  FValue[0] := e0;
  FValue[1] := e1;
  FValue[2] := e2;
  FValue[3] := e12;
end;

function TGA2Dmv.GetElmt( idx: integer ): real;
begin
  result := fvalue[idx];
end;

function TGA2Dmv.mag: real;
begin
  result := sqrt(
    fvalue[0] * fvalue[0] +
    fvalue[1] * fvalue[1] +
    fvalue[2] * fvalue[2] +
    fvalue[3] * fvalue[3]
    );
end;

function TGA2Dmv.mul( opd: TGA2DObject ): TGA2DObject;
begin
  result := tga2dmv.Create(
    ( fvalue[0] * opd.Elmt[0] + fvalue[1] * opd.Elmt[1] + fvalue[2] * opd.Elmt[2] - fvalue[3] * opd.Elmt[3] ),
    ( fvalue[0] * opd.Elmt[1] + fvalue[1] * opd.Elmt[0] - fvalue[2] * opd.Elmt[3] + fvalue[3] * opd.Elmt[2] ),
    ( fvalue[0] * opd.Elmt[2] + fvalue[1] * opd.Elmt[3] + fvalue[2] * opd.Elmt[0] - fvalue[3] * opd.Elmt[1] ),
    ( fvalue[0] * opd.Elmt[3] + fvalue[1] * opd.Elmt[2] - fvalue[2] * opd.Elmt[1] + fvalue[3] * opd.Elmt[0] )
    );
end;

procedure TGA2Dmv.neg;
begin
  inherited;
  fvalue[0] := -fvalue[0];
  fvalue[1] := -fvalue[1];
  fvalue[2] := -fvalue[2];
  fvalue[3] := -fvalue[3];
end;

procedure TGA2Dmv.nor;
var
  len               : real;
begin
  inherited;
  len := mag;
  if len > 1E-3 then begin
    fvalue[0] := fvalue[0] / len;
    fvalue[1] := fvalue[1] / len;
    fvalue[2] := fvalue[2] / len;
    fvalue[3] := fvalue[3] / len;
  end;
end;

function TGA2Dmv.sub( opd: TGA2DObject ): TGA2DObject;
begin
  result := tga2dmv.Create( FValue[0] - opd.Elmt[0], FValue[1] - opd.Elmt[1], FValue[2] - opd.Elmt[2], FValue[3] - opd.Elmt[3] );
end;

{ TGA2Dc }

function TGA2Dc.add( opd: TGA2DObject ): TGA2DObject;
begin
  if ( opd is tga2ds ) or ( opd is tga2dc ) then
    result := tga2dc.Create( fvalue[0] + opd.Elmt[0], fvalue[1] + opd.Elmt[3] )
  else
    result := tga2dmv.Create( fvalue[0] + opd.Elmt[0], opd.Elmt[1], opd.Elmt[2], fvalue[1] + opd.Elmt[3] );
end;

constructor TGA2Dc.Create( e0, e12: real );
begin
  FValue[0] := e0;
  FValue[1] := e12;
end;

function TGA2Dc.GetElmt( idx: integer ): real;
begin
  if idx = 0 then
    result := fvalue[0]
  else
    if idx = 3 then
      result := fvalue[1]
    else
      result := 0;
end;

function TGA2Dc.mag: real;
begin
  result := sqrt(
    fvalue[0] * fvalue[0] +
    fvalue[1] * fvalue[1]
    );
end;

function TGA2Dc.mul( opd: TGA2DObject ): TGA2DObject;
begin
  if opd is tga2ds then
    result := opd.mul( self )
  else
    if opd is tga2dv then
      result := tga2dv.Create( ( fvalue[0] * opd.Elmt[1] + fvalue[1] * opd.Elmt[2] ), ( fvalue[0] * opd.Elmt[2] - fvalue[1] * opd.Elmt[1] ) )
    else
      if opd is tga2dbv then
        result := tga2dc.Create( -fvalue[1] * opd.Elmt[3], fvalue[0] * opd.Elmt[3] )
      else
        if opd is tga2dc then
          result := tga2dc.Create( ( fvalue[0] * opd.Elmt[0] - fvalue[1] * opd.Elmt[3] ), ( fvalue[0] * opd.Elmt[3] + fvalue[1] * opd.Elmt[0] ) )
        else
          result := tga2dmv.Create(
            ( fvalue[0] * opd.Elmt[0] - fvalue[1] * opd.Elmt[3] ),
            ( fvalue[0] * opd.Elmt[1] + fvalue[1] * opd.Elmt[2] ),
            ( fvalue[0] * opd.Elmt[2] - fvalue[1] * opd.Elmt[1] ),
            ( fvalue[0] * opd.Elmt[3] + fvalue[1] * opd.Elmt[0] )
            );
end;

procedure TGA2Dc.neg;
begin
  inherited;
  fvalue[0] := -fvalue[0];
  fvalue[1] := -fvalue[1];
end;

procedure TGA2Dc.nor;
var
  len               : real;
begin
  inherited;
  len := mag;
  if len > 1E-3 then begin
    fvalue[0] := fvalue[0] / len;
    fvalue[1] := fvalue[1] / len;
  end;
end;

function TGA2Dc.sub( opd: TGA2DObject ): TGA2DObject;
begin
  if ( opd is tga2ds ) or ( opd is tga2dc ) then
    result := tga2dc.Create( fvalue[0] - opd.Elmt[0], fvalue[1] - opd.Elmt[3] )
  else
    result := tga2dmv.Create( fvalue[0] - opd.Elmt[0], -opd.Elmt[1], -opd.Elmt[2], fvalue[1] - opd.Elmt[3] );
end;

end.

