class CriaturaMagica {
  var salud

  method sufrirHechizo(unDanio) {
    salud = salud - unDanio
  }
}

class Behemoth inherits CriaturaMagica {
  override method sufrirHechizo(unDanio) {
    salud = salud - 0
  } 
}

class Estudiante inherits CriaturaMagica {
  var casa
  var sangrePura
  var habilidad
  const hechizos = #{}

  method esPeligroso() = casa.condicion(self)
  method sufrir(unDolor) {
    salud = salud - unDolor
  } 
  method curarse(unaCant) {
    salud = salud + unaCant
  }
  method cambiarCasa(unaCasa) {
    casa = unaCasa
  }
  method habilidad() = habilidad
  method sangrePura() = sangrePura
  method aprender(unHechizo) {
    hechizos.add(unHechizo)
  }
  method puedeUsar(unHechizo) = if(hechizos.contains(unHechizo) && unHechizo.condicionEspecial(self) && habilidad > unHechizo.nivDificultad()){
    return true 
  } else {
    self.error("Sos muy tontito como para hechizar")
  }
  method aumentarHabilidad(unNumero) {
    habilidad += unNumero
  }
  method realizarHechizoContra(unHechizo, unaCriatura) {
    if(hechizos.contains(unHechizo)) {
      unHechizo.castear()
    }
    unHechizo.consecuenciaDeUso(self)
  }
  method perderHabilidad(unaCant) {
    habilidad = habilidad - unaCant
  }
  method inscribirse(unaMateria) {
    unaMateria.agregar(self)
  }
  method darDeBaja(unaMateria) {
    unaMateria.expulsar(self)
  }
}

class Casa {
  method condicion(unEstudiante)  
}

object gryffindor inherits Casa {
  override method condicion(unEstudiante) = false
}

object slytherin inherits Casa {
  override method condicion(unEstudiante) = true
} 

object ravenclaw inherits Casa {
  override method condicion(unEstudiante) = unEstudiante.habilidad() > 10
}

object huffelpuff inherits Casa {
  override method condicion(unEstudiante) = unEstudiante.sangrePura()
}

class MateriaMagica {
  const profesor
  var hechizo
  const alumnos = #{}

  method dictarMateria() = alumnos.forEach({a => a.aprender(hechizo).aumentarHabilidad(1)})
  method cambiarHechizo(unHechizo) {
    hechizo = unHechizo
  }
  method agregar(unAlumno) {
    alumnos.add(unAlumno)
  }
  method expulsar(unAlumno) {
    alumnos.remove(unAlumno)
  }
  method hacerPracticaContra(unaCriatura) = alumnos.forEach({a => a.realizarHechizoContra(hechizo, unaCriatura)})
}

class Hechizo {
  var nivDificultad = 1
  var dolorUnico = 5

  method nivDificultad() = nivDificultad
  method set(unNumero) {
    nivDificultad = unNumero
  }
  method condicionEspecial(unEstudiante) = nivDificultad > 1
}

class HechizoComun inherits Hechizo {
  method castear(unObjetivo) {
    unObjetivo.sufrirHechizo(self.potenciaHechizo())
  } 
  method consecuenciaDeUso(casteador) = null 
  method potenciaHechizo() = (self.nivDificultad() * 10)
}

class HechizoImperdonable inherits HechizoComun {
  override method potenciaHechizo() = super() * 2
  override method consecuenciaDeUso(casteador) = casteador.sufrir(dolorUnico)
}

object sectumSempra inherits HechizoComun {
  override method condicionEspecial(unEstudiante) = not unEstudiante.esPeligroso()
  override method consecuenciaDeUso(casteador) = casteador.perderHabilidad(1)
}

object testicularTorsion inherits HechizoImperdonable {
  override method condicionEspecial(unEstudiante) = unEstudiante.esPeligroso() && not unEstudiante.sangrePura()
  override method consecuenciaDeUso(casteador) = casteador.cambiarCasa(gryffindor)
}