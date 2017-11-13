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
	
	/*Estategia para buscar los materiales en la mochila */
	var estrategia = azar 

	/*Set para cambiar de compañero */
	method companero(unCompanero) {
		companero = unCompanero
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
		estrategia.algunMaterialQueCumpla(self.todosMaterialesQueCumplen(condicion)) 
	
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

/*Estrategia para elegir los materiales de la mochila */
class Estrategia {	
	/*Devuelve algun material de la mochila. */
	method algunMaterialQueCumpla(mochila)	
}

/*Al azar: Se elige cualquier elemento de la mochila*/
object azar inherits Estrategia{
	override method algunMaterialQueCumpla(mochila) = mochila.anyOne()
} 

/*Menor cantidad de metal: Se elige de entre todos los elementos, 
 * aquel que tiene la menor cantidad de metal.*/
object menorMetal inherits Estrategia{
	override method algunMaterialQueCumpla(mochila) = mochila.min{m => m.gramosDeMetal()}
}

/*Mejor generador eléctrico: Se elige de entre todos los elementos, 
 * aquel que produce la mayor cantidad de energía */ 
object mejorGenerador inherits Estrategia{
	override method algunMaterialQueCumpla(mochila) = mochila.max{m => m.energia()}
}

/*Ecológico: De entre todos los elementos, intenta utilizar un ser vivo. 
 * En caso de que ninguno lo sea, intenta usar un elemento que no sea radiactivo.*/
object ecologico inherits Estrategia{

	override method algunMaterialQueCumpla(mochila) = 
		mochila.findOrElse({m => m.estaVivo()}, {
			mochila.findOrElse({m => !m.esRadiactivo()}, {
				mochila.anyOne()
			})
		})
}









