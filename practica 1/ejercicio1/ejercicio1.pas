{
    Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
    incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
    archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
    se ingrese el número 30000, que no debe incorporarse al archivo.
}

program ejercicio1;
const
    valor_corte = 3000;
var
    archivo_maestro: file of integer;
    nombre_archivo : string[25];
    numeros_ingresados : integer;
begin
    write('ingrese nombre del archivo: ');
    readln(nombre_archivo);
    Assign(archivo_maestro,nombre_archivo);
    rewrite(archivo_maestro);

    write('Ingrese un numero: ');
    readln(numeros_ingresados);

    reset(archivo_maestro);
    
    while(numeros_ingresados <> valor_corte) do begin
        write(archivo_maestro,numeros_ingresados);
        write('Ingrese un numero: ');
        readln(numeros_ingresados);
    end;

    close(archivo_maestro);
end.