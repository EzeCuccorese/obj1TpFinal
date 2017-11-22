/*Representa un material en general. 
* Clase Abstracta  */
class Material {
	/*Gramos de metal del material. 
	 * Metodo Abstracto */
	method gramosDeMetal()
	
	/*Electricidad que puede conducir el material. */
	method electricidad() = 0
	
	/*Energia que produce el material. */
	method energia() = 0
	
	/*Indica si el material es radiactivo. */
	method esRadiactivo() = false
	
	/*Indica si el material es conductor de energia.*/
	method esConductor() = self.electricidad() > 0
	
	/*Indica si el material es generador de energia.*/
	method esGenerador() = self.energia() > 0
	
	/* Indica si la cantidad de gramos de metal que tiene el material es mayor a 
	 * cierto numero.*/
	method gramosDeMetalMayorA(unosGramos) = self.gramosDeMetal() > unosGramos
	
	/*Indica la energia requerida para poder ser recogido. */
	method energiaRequerida() = self.gramosDeMetal()
	
	/*El efecto que produce sobre el recolector. */
	method efectoSobreRecolector(unRecolector){
		unRecolector.modificarEnergiaPorMaterial(- self.energiaRequerida())		
	}
	
	/*Indica si el material esta vivo. */
	method estaVivo() = false
}

/*Modela una lata. */
class Lata inherits Material {
	//Cantidad de gramos de metal que tiene la lata.
	const gramos
	
	/*Constructor de clase donde pasamos la cantidad de gramos de metal. */
	constructor(_gramos) {
		gramos = _gramos
	}
	
	/*Devuelve la cantidad de gramos de metal que posee. */
	override method gramosDeMetal() = gramos
	
	/*Devuelve la energia que puede conducir. */
	override method electricidad() = 0.1 * self.gramosDeMetal()
}

/*Modela un cable. */
class Cable inherits Material {

	//La longitud del cable en metros.
	const longitud
	
	//La seccion del cable en cm3.
	const seccion

	/*Constructor del cable, recibe la longitud y la seccion que tiene. */
	constructor(_longitud, _seccion) {
		longitud = _longitud 
		seccion = _seccion
	}
	
	/*Calcula la cantidad de gramos de metal en base a la longitud y la seccion. */
	override method gramosDeMetal() = ( longitud / 1000 ) * seccion
	
	/*Calcula la energia que conduce en base a la seccion. */
	override method electricidad() = 3 * seccion
}

/* Modela materia oscura contiene un material base. La conductividad es la mitad de la base,
 * la cantidad de metal es la misma que la base, no es radiactivo, y genera el doble de 
 * energía que la base. */
class MateriaOscura inherits Material {
	//Material de base, puede ser cualquier tipo de otro material.
	const materialBase 

	/*Material de base con el que se construye. */
	constructor(_materialBase) {
		materialBase = _materialBase
	}

	/* Sobreescritura del metodo gramosDeMetal.Retorna los gramos de metal del material basecon el que se construye.*/		
	override method gramosDeMetal() = materialBase.gramosDeMetal()

	/* Sobreescritura del metodo electricidad.Retorna la electricidad del material base con el que se construye.*/		
	override method electricidad() = materialBase.electricidad() / 2

	/* Sobreescritura del metodo rnergia.Retorna la energia del material base con el que se construye.*/		
	override method energia() = materialBase.energia() * 2
}

/*Es el material resultante luego de realizar un experimento. */
class MaterialDeExperimento inherits Material {
	
	const componentes
	
	constructor(_componentes) {
		componentes = _componentes
	}
	
	/*El peso en gramos de metal es la sumatoria de los de sus componentes. */
	override method gramosDeMetal() = componentes.sum{ c => c.gramosDeMetal() }
}

/*Material resultante del experimento que crea una bateria. */
class Bateria inherits MaterialDeExperimento {
	/*Bateria siempre es radiactiva */
	override method esRadiactivo() = true
	
	/*Energia es el doble de sus gramos de metal */
	override method energia() = 2 * self.gramosDeMetal()
}

/*Material resultante del experimento que crea un circuito. */
class Circuito inherits MaterialDeExperimento {
	
	/*Es la sumatoria de la electricidad de sus componentes, multiplicado por 3 */
	override method electricidad() = 3 * componentes.sum{ c => c.electricidad() }
	
	/*Es radiactivo si y solo si alguno de sus componentes son radiactivos. */
	override method esRadiactivo() = componentes.any{ c => c.esRadiactivo() }
}

class MaterialVivo inherits Material {
	
	/*Indica si el material esta vivo. */
	override method estaVivo() = true
	
}

/*Model aun Fleeb. */
class Fleeb inherits MaterialVivo {

	//Edad en años.
	const edad
	
	//Materiales que tiene en el estomago.
	const estomago = #{ }

	/*Constructor, recibe por parametros la edad que tiene. */
	constructor(_edad) {
		edad = _edad
	}
	
	/*Come un material y se guarda en el estomago. */
	method comer(unMaterial) {
		estomago.add(unMaterial)
	}
	
	/*Gramos de metal que tiene, se calcula en base a lo que tiene dentro del estomago,
	 * es la sumatoria de todos los materiales. */
	override method gramosDeMetal() = 
				if (estomago.isEmpty()) 0 
				else estomago.sum{ m => m.gramosDeMetal() }
				
	/*Electricidad que conduce, se calcula en base al material que menos conduce de los 
	 * que tiene en el estomago. */
	override method electricidad() = 
				if (estomago.isEmpty()) 0 
				else estomago.map{ m => m.electricidad() }.min()
	
	/*Si el Fleeb tiene más de 15 años se convierte en un material radiactivo. */
	override method esRadiactivo() = edad > 15
	
	/*Energia que genera, se calcula en base al material que mas energia genera de los 
	 * que tiene en el estomago. */	
	override method energia() = 
				if (estomago.isEmpty()) 0 
				else estomago.map{ m => m.energia() }.max()
	
	/*Energia requerida para recolectarlo, implica el doble de gasto de lo que requiere
	 * un material comun. */		
	override method energiaRequerida() = super() * 2 
	
	/*Efecto que produce sobre su recolector, si el Fleeb no es radiactivo otorga 10
	 * puntos extras de energia, a parte le descuenta energia como cualquier otro material. */
	override method efectoSobreRecolector(unRecolector){
		super(unRecolector)
		if (!self.esRadiactivo()){
			unRecolector.modificarEnergiaPorMaterial(10)	
		}
	}
}

/* Un parásito alienígena es un elemento vivo que morty puede recolectar. No es 
 * radiactivo, produce 5 amperes de electricidad, tiene 10 gramos de metal y 
 * no conduce la electricidad. 
  */
class ParasitosAlienigenas inherits MaterialVivo{
	
	/* Las acciones que se realizan y el orden de las mismas se configuran al inicio 
 	* del juego para cada instancia de un Parásito Alienígena con el cual se 
 	* quiera jugar.*/
	const acciones
	
	/*Constructor para configurar las acciones a realizar en la instancia del parasito. */
	constructor(_accionesConfiguradas){
		acciones = _accionesConfiguradas
	}
	/*Gramos de metal del material. */
	override method gramosDeMetal() = 10
	
	/*Electricidad que puede conducir el material. */
	override method electricidad() = 5
	
	/*Indica si el material es conductor de energia.*/
	override method esConductor() = false
	
	/*Cuando​ ​es​ ​recolectado​, el recolector sufre una alteración en su personalidad realizando 
	 * una o más acciones forzosamente.  */
	override method efectoSobreRecolector(unRecolector){
		acciones.forEach{a => a.ejectuarAccion(unRecolector)} 
	}
}

