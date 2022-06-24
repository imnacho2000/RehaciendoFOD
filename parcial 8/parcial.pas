program parcial;
const
    valor_alto = 9999;
type 
    persona = record
        dni:integer;
        nombre:string[25];
        apellido:string[25];
        sueldo:real;
    end;

    tArchivo = file of persona;

    procedure leer(var info:Text; var regM: persona);
    begin
        if not eof(info) then begin
            readln(info,regM.dni,regM.nombre);
            readln(info,regM.sueldo,regM.apellido)
        end
        else
            regM.dni := valor_alto;
    end;

    procedure crear(var arch:tArchivo; var info:Text);
    var

        regM:persona;
    begin  
        rewrite(arch);
        regM.dni := 0;
        write(arch,regM); 
        reset(info);
        readln(info,regM.dni,regM.nombre);
        readln(info,regM.sueldo,regM.apellido);
        while(not eof(info)) do begin
            write(arch,regM);
            leer(info,regM);
        end;
        close(arch);
        close(info);
    end;
    

    procedure agregar(var arch:tArchivo ; p:persona);
    var
        regM,regMaux:persona;
    begin
        reset(arch);
        leer(arch,regM);
        if (regM.dni > 0) then begin 
            seek(arch,filesize(arch));
            write(arch,p)
        end
        else begin
            seek(arch,(regM.dni* -1));
            leer(arch,regMaux);
            seek(arch,filepos(arch) -1);
            write(arch,p);
            seek(arch,0);
            write(arch,regMaux)
        end;
        close(arch);
    end;


    procedure eliminar(var arch: tArchivo; dni:integer);
    var
        regM:persona;
        head:integer;
    begin
        reset(arch);
        read(arch,regM);
        head:= regM.dni;
        while not eof(arch) and (regM.dni <> dni)do begin
            read(arch,regM);
        if(regM.dni = dni) then begin
            regM.dni := head;
            seek(arch,filepos(arch)-1);
            head:= (filepos(arch)* -1);
            write(arch,regM);
            seek(arch,0);
            regM.dni := head;
            write(arch,regM);
        end
        else 
            write('La persona con dni ', dni, ' no existe.');
        end;
        close(arch);
    end; 


var

begin

end.
