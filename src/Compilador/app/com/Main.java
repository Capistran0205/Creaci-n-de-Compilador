/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Compilador.app.com;

import java.io.File;

/**
 *
 * @author capis
 */
public class Main {

    /**
     * @param args the command line arguments
     */
// Método principal: el punto de entrada de cualquier aplicación Java
    public static void main(String[] args) {

        // Ruta del archivo .flex que contiene las reglas del analizador léxico
        String ruta = "C:/Users/capis/OneDrive/Documentos/NetBeansProjects/Compilador/src/AnalizadorLexico/app/com/Lexer.flex";

        // Llama al método que genera el analizador léxico a partir del archivo .flex
        generarLexer(ruta);
    }

// Método que genera el analizador léxico usando JFlex
    public static void generarLexer(String ruta) {

        // Crea un objeto File con la ruta al archivo .flex
        File archivo = new File(ruta);

        // Usa la clase de JFlex para generar el código del analizador léxico
        JFlex.Main.generate(archivo);
    }

}
