ZSH_CONFIG_DIR="${HOME}/.config/zsh"

# why don't you use the credit card? you'll get miles
for file in ${ZSH_CONFIG_DIR}/[0]?-*.zsh; do 
    source ${file}
done

# for here in the great, infinite uknowable - man can come to know the most
# important thing of all, himself. he can understand... wtf am I doing? 
# hahahaha *boom*...
# get ready to pull a few Gs. 420 knots, this is more like it (ha nice).
for file in ${ZSH_CONFIG_DIR}/[1-9]?-*.zsh; do 
    source ${file}
done

# just pray we don't run into any dead-ends or we're going to miss those lasers
# ok, navigator, which way?
# we've got greater flow density on the left - go with the flow.
platform=$(uname)
case "${platform}" in
    Darwin)
        echo "apple bottomed jeans detected.."
        source ${ZSH_CONFIG_DIR}/platform.darwin.zsh
        ;;
    linux)
        echo "i use arch, btw.."
        source ${ZSH_CONFIG_DIR}/platform.linux.zsh
        ;;
esac
