# SPDX-License-Identifier: BSD-3-Clause

#
# define Makefile targets that are specific to an environment.
#
include $(RTE_SDK)/mk/exec-env/$(RTE_EXEC_ENV)/rte.app.mk

.PHONY: exec-env-appinstall
target-appinstall: exec-env-appinstall

.PHONY: exec-env-appclean
target-appclean: exec-env-appclean
