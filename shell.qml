//@ pragma UseQApplication

import Quickshell
import "./common"
import "./services"
import "./modules"
import "./modules/bar"
import "./modules/sidebarRight"

ShellRoot {
    Scope {
        ColorReadout {}
        SidebarRight {}
        Bar {}
        PowerMenu {}
    }
}