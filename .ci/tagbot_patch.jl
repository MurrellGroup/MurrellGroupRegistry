using RegistryCI.TagBot

# Patch: recognize push events as cron-like
@eval TagBot begin
    is_cron(event) = get(ENV, "GITHUB_EVENT_NAME", "") in ("schedule", "workflow_dispatch", "push")
end

# Patch: scan commits instead of PRs (LocalRegistry commits directly, no PRs)
@eval TagBot begin
    function handle_cron(event)
        repo = ENV["GITHUB_REPOSITORY"]
        since = string(now(UTC) - Day(3))
        commit_list, _ = GH.commits(repo; auth=AUTH[], params=(; since, per_page=100))

        registrations = map(commit_list) do c
            msg = c.commit.message
            # LocalRegistry format:
            #   New version: PkgName v1.2.3
            #
            #   UUID: ...
            #   Repo: https://github.com/Org/PkgName.jl
            #   Tree: ...
            m = match(r"New version:\s+(\S+)\s+v(\S+)", first(split(msg, '\n')))
            pkg_name = m === nothing ? nothing : strip(m[1])
            version = m === nothing ? nothing : "v$(strip(m[2]))"
            m = match(r"Repo: .*github\.com[:/](.*)", msg)
            pkg_repo = m === nothing ? nothing : strip(m[1])
            pkg_repo !== nothing && endswith(pkg_repo, ".git") && (pkg_repo = pkg_repo[1:end-4])
            (pkg_repo, pkg_name, version)
        end

        filter!(rv -> rv[1] !== nothing && rv[2] !== nothing && rv[3] !== nothing, registrations)
        unique!(registrations)
        for (pkg_repo, pkg_name, version) in registrations
            @info "Processing version $version of $pkg_repo ($pkg_name)"
            maybe_notify(event, pkg_repo, version; cron=true)
        end
    end
end

TagBot.main()
