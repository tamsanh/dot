CURR_DIR=$(cd `dirname $0`; pwd)

# Install vimrc
ln -s $CURR_DIR/vimrc ~/.vimrc

# Install awesome
mkdir ~/.config/
ln -s $CURR_DIR/awesome ~/.config/awesome

# Install bashrc
echo "source $CURR_DIR/bashrc" >> ~/.bashrc
