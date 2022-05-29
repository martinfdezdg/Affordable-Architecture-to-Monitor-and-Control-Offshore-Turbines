# Arquitectura-asequible-para-monitorizar-y-controlar-turbinas-offshore  

## Resumen
La energía eólica marina juega un papel clave en la transición ecológica. Las turbinas eólicas flotantes requieren de nuevos y más complejos algoritmos de control y métodos de comunicación. Este proyecto propone un sistema asequible de monitorización y control de diferentes prototipos de turbina, reales o simulados.  

En primer lugar, se analizan el modelado y las técnicas de control de las turbinas eólicas, así como la problemática de su implantación en alta mar. También se introduce el concepto de Gemelo Digital junto con sus utilidades en la materia.  
La aplicación de un lazo de control básico y la monitorización del estado del sistema en tiempo real sobre un prototipo de baja fidelidad evidencia la necesidad de más de un hilo de ejecución. Se solventa con el uso de un microcontrolador de varios núcleos, colas de comunicación entre hilos y del formato JSON para la encapsulación y subida de datos al servidor de ThingSpeak.  
La interfaz de control del sistema se materializa en un Gemelo Digital. Su desarrollo se lleva a cabo en el entorno MATLAB con el patrón de diseño Modelo-Vista-Controlador, lo que facilita su uso para ingenieros de otras ramas y favorece su escalabilidad. El Gemelo Digital permite monitorizar en tiempo real las turbinas de una granja eólica, formada particularmente por un prototipo físico y por una simulación, así como enviarle comandos, ajustando de forma remota el ángulo de las palas, la carga eléctrica o ejecutando paradas de emergencia.  
El software integrado con ejecución multihilo se encarga del control de los componentes del prototipo de turbina escalado y es capaz de comunicarse bidireccionalmente con el Gemelo Digital. Resulta de una fusión con algoritmos de control PID modelados por miembros de otras disciplinas del grupo de trabajo.  
Por último, se muestran diferentes casos de uso del funcionamiento del prototipo de turbina eólica y del simulador a través de la interfaz del Gemelo Digital.

<br>
<p align=center valign="center">
  <img alt="Prototipo de turbina eólica flotante" src="Documentation/Images/prototype.png" width="25%" align="middle">
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
  <img alt="Gemelo Digital de turbina eólica flotante" src="Documentation/Images/digital_twin.png" width="50%" align="middle">
</p> 
</br>

## Aportaciones

### [Aprendizaje y dominio de las tecnologías](https://github.com/martinfdezdg/Affordable-Architecture-to-Monitor-and-Control-Offshore-Turbines/tree/main/Wind%20Turbine%20Software/Embedded%20Controlling%20Software/multithread-imu-servo-thingspeak)
Introducción de las herramientas y las soluciones necesarias para el desarrollo de un prototipo de monitorización y control de una turbina eólica de baja fidelidad. La base del proyecto, un microcontrolador mononúcleo, componentes hardware sencillos, el entorno de desarrollo de Arduino y el servidor ThingSpeak, tuvo que ser modificada para solucionar limitaciones y alcanzar el resultado deseado. Para evitar los tiempos de espera en las instrucciones de comunicación con el servidor, se sustituye el microcontrolador mononúcleo por otro con dos procesadores; para sortear las limitaciones de la licencia gratuita de ThingSpeak se empaquetan y suben los datos en formato de archivo JSON.

### [Interfaz de control del Gemelo Digital](https://github.com/martinfdezdg/Affordable-Architecture-to-Monitor-and-Control-Offshore-Turbines/tree/main/Wind%20Turbine%20Software/Digital%20Twin)
Implementación completa del Gemelo Digital de una granja eólica. Expone el novedoso proceso de cómo aplicar el patrón de diseño Modelo-Vista-Controlador en MATLAB y cuál ha sido el resultado de cada una de sus partes. En primer lugar, el modelo se encarga de acceder a ThingSpeak y de almacenar la información del estado y la estabilidad de la turbina, así como de gestionar el envío de comandos. En segundo lugar, la vista muestra dicha información al usuario y le permite interactuar con las turbinas mediante una interfaz que cumple con los principios de diseño. En tercer lugar, el controlador gestiona los eventos de la vista y del modelo y fuerza a que se muestren datos actualizados mediante el uso de temporizadores. Por último, se ha presentado el simulador de turbina eólica flotante creado para realizar pruebas en el Gemelo Digital y se ha visto cómo atajar los problemas de su funcionamiento en tiempo real.

### [Software integrado en el prototipo](https://github.com/martinfdezdg/Affordable-Architecture-to-Monitor-and-Control-Offshore-Turbines/tree/main/Wind%20Turbine%20Software/Embedded%20Controlling%20Software/prototype)
Desarrollo del software integrado en el microcontroaldor ESP32 del prototipo de turbina eólica. Antes de proceder al desarrollo, se muestra el prototipo del que se dispone y sus componentes. Comienza esbozando el software de manera general e introduciendo las estructuras internas de datos. También hace especial énfasis en las estructuras encargadas de la comunicación entre hilos mediante paso de mensajes. A continuación, describe las estructuras partiendo de las más concretas para llegar a las más abstractas: primero, los monitores y los controladores, y después, la clase de la tarea de la turbina y la clase de la tarea de las comunicaciones.
