self: super: {
    vim_configurable = super.vim_configurable.override {
        vimrc = self.writeText "vimrc" ''
            set nocompatible
            set number
            set bs=2
            colo 256_noir
        '';
    };
}
