import Experimentos.*
import Companieros.*
import Materiales.*

/*Representa al modelado de el cientifico rick. */
object rick {
	//El compañero de rick.
	var companero = morty
	
	//La mochila donde lleva sus materiales.
	const mochila = #{}
	
	//Los experimentos que conoce rick y puede llegar a realizar.
	const experimentosConocidos = #{construirBateria, construirCircuito, shockElectrico} 

	/*Set para cambiar de compañero */
	method companero(unCompanero) {
		companero = unCompanero
		self.causarEfectoEnCompaniero(unCompanero)
	}
	
	method causarEfectoEnCompaniero(unCompanero){
		unCompanero.efectoDeRick()
		
	}
	
	/* Modifica la energia del comapañero en cierta cantidad */
	method modificarEnergiaCompanero(unaCantidad){
		companero.modificarEnergia(unaCantidad)
	}
	
	/*Agrega un material en particular a la mochila. */
	method agregar(unMaterial) {
		mochila.add(unMaterial)
	}
	
	/*Recibe un conjunto de materiales para guardar en la mochila */
	method recibir(unosMateriales) {
		mochila.addAll(unosMateriales)
	}
	
	/*Devuelve el conjunto de materiales que tiene en la mochila rick. */
	method materialesMochila() = mochila
	
	/*Remueve un conjunto de materiales de la mochila. */
	method remover(unosMateriales){
		mochila.removeAll(unosMateriales)	
	}
	
	/*Si algun material cumple con la condicion. */
	method algunMaterialCumple(condicion) = mochila.any(condicion)
	
	/*Devuelve algun material que cumpla con la condicion. */
	method algunMaterialQueCumpla(condicion) = 
		self.todosMaterialesQueCumplen(condicion).anyOne() 
	
	/*Devuelve todos los materiales que cumplen con la condicion */
	method todosMaterialesQueCumplen(condicion) = mochila.filter(condicion) 

	/* Rick sabe un conjunto de experimentos, pero queremos
		saber de esos cuáles son los que puede hacer con las 
		cosas que tiene actualmente en su mochila. */
	method experimentosQuePuedeRealizar() = 
		experimentosConocidos.filter{e => e.puedeRealizarse(self)}
	
	/*Valida si un experimento puede ser llevado a cabo. */	
	method validarRealizacionDeExperimento(unExperimento){
		if (! unExperimento.puedeRealizarse(self)){
		    self.error("No puede realizarse el experimento " + unExperimento)		}		
	}

	/*Realiza un experimento, en caso de que no pueda llevarse a cabo arroja un error */
	method realizar(unExperimento) {	
		self.validarRealizacionDeExperimento(unExperimento)
		unExperimento.realizar(self)
	}
}
