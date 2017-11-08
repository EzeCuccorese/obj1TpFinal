import Experimentos.*

object rick {
	var companero
	const mochila = #{ }
	const experimentosConocidos = #{construirBateria, construirCircuito, shockElectrico }

	method companero() = companero
	
	method companero(unCompanero) {
		companero = unCompanero
	}
	method mochila() = mochila
	
	method agregar(unMaterial) {
		mochila.add(unMaterial)
	}
	method recibir(unosMateriales) {
		mochila.addAll(unosMateriales)
	}

	/* Rick sabe un conjunto de experimentos, pero queremos
		saber de esos cuáles son los que puede hacer con las 
		cosas que tiene actualmente en su mochila. */
	method experimentosQuePuedeRealizar() = experimentosConocidos.filter{
							e => e.puedeRealizarse(mochila) }

	method realizar(unExperimento) {
		if (! self.experimentosQuePuedeRealizar().contains(unExperimento)) {
			self.error("No puede realizarse el experimento " + unExperimento)
		}

		//Se buscan los materiales necesarios de la mochila de Rick
		unExperimento.construir(self)

		//Se remueven los materiales de la mochila de Rick.
		mochila.removeAll(unExperimento.materialesParaConstruir(mochila))

		/* Se aplica el efecto del experimento, 
		 por ejemplo si se trata de la construcción de la batería, 
		 se debe agregar una nueva batería a la mochila de Rick, 
		 pero si se trata de un shock eléctrico se debe 
		 incrementar la energía del compañero de Rick.
		*/
	}
}
