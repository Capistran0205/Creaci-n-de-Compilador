/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Compilador.app.com;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 *
 * @author capis
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception {
        // Ruta del archivo .flex que contiene las reglas del analizador léxico
        String ruta = "C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorLexico/app/com/Lexer.flex"; // Para el lexer
        String ruta1 = "C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorSintactico/app/com/LexerCup.flex"; // Lexer para el sintáctico
        String[] rutasS = {"-parser", "Syntax", "C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorSintactico/app/com/Syntax.cup"
        };
        // generarLex(ruta);
        generarLexAndCup(ruta1, rutasS);
    }
    public static void generarLex(String rutaLex){
        File archivo;
        archivo = new File(rutaLex);
        JFlex.Main.generate(archivo);
    }
    public static void generarLexAndCup(String rutaCup, String [] rutasS) throws IOException, Exception{
        File archivo;
        archivo = new File(rutaCup); // Archivo del lexer para el sintáctico
        JFlex.Main.generate(archivo); // Creación del Lexer para el sintáctico
        java_cup.Main.main(rutasS);

        Path rutaSym = Paths.get("C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorSintactico/app/com/sym.java");
        if (Files.exists(rutaSym)) {
            Files.delete(rutaSym); // Eliminación del paquete, permitiendo generar uno nuevo en caso de ser necesario                       
        }
        Files.move(Paths.get("C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/sym.java"),
                Paths.get("C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorSintactico/app/com/sym.java"));

        Path rutaSyn = Paths.get("C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorSintactico/app/com/Syntax.java");
        if (Files.exists(rutaSyn)) {
            Files.delete(rutaSyn); // Eliminación del paquete, permitiendo generar uno nuevo en caso de ser necesario
        }
        Files.move(Paths.get("C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/Syntax.java"),
                Paths.get("C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorSintactico/app/com/Syntax.java"));
    }    
}
