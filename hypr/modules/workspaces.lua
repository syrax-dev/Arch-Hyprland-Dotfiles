-- Workspace rules

-- Persistent workspaces
hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })

-- Special workspace
hl.workspace_rule({
    workspace   = "special:magic",
    gaps_out    = 20,
    gaps_in     = 10,
    border_size = 3,
    decorate    = true,
})
