import Experimentos.*
import Companieros.*
import Materiales.*

object rick inherits wollok.lang.Object{
	var companero = morty
	const mochila = #{}
	const experimentosConocidos = #{construirBateria, construirCircuito, shockElectrico} 

	method companero() = companero
	
	method companero(unCompanero) {
		companero = unCompanero
	}
	
	method modificarEnergiaCompanero(unaCantidad){
		companero.modificarEnergia(unaCantidad)
	}
	
	method agregar(unMaterial) {
		mochila.add(unMaterial)
	}
	method recibir(unosMateriales) {
		mochila.addAll(unosMateriales)
	}
	method materialesMochila() = mochila
	
	method remover(unosMateriales){
		mochila.removeAll(unosMateriales)	
	}
	
	method algunMaterialCumple(condicion) = mochila.any(condicion)
	method algunMaterialQueCumpla(condicion) = mochila.anyOne(condicion) 
	method todosMaterialesQueCumplen(condicion) = mochila.filter(condicion) 

	/* Rick sabe un conjunto de experimentos, pero queremos
		saber de esos cuáles son los que puede hacer con las 
		cosas que tiene actualmente en su mochila. */
	method experimentosQuePuedeRealizar() = 
		experimentosConocidos.filter{e => e.puedeRealizarse(self)}
		
	method validarRealizacionDeExperimento(unExperimento){
		if (! unExperimento.puedeRealizarse(self)){
		    self.error("No puede realizarse el experimento " + unExperimento)		}		
	}

	method realizar(unExperimento) {	
		self.validarRealizacionDeExperimento(unExperimento)
		unExperimento.realizar(self)
	}
}
