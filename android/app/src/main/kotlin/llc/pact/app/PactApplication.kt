package llc.pact.app

import android.app.Application
import llc.pact.app.data.PactRepository

class PactApplication : Application() {
    // v1 uses a singleton repository held on the Application. Upgrades to Koin
    // + DataStore-backed persistence land in v1.1.
    val repository: PactRepository by lazy { PactRepository.createSeeded() }

    override fun onCreate() {
        super.onCreate()
        INSTANCE = this
    }

    companion object {
        lateinit var INSTANCE: PactApplication
            private set
    }
}
