module StaticPagesHelper
    def is_active(path)
        if path == request.original_fullpath
            "class=active"
        end
    end
end
